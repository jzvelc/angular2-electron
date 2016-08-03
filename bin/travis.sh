#!/bin/bash

set -euo pipefail

GH_TOKEN="${GH_TOKEN:-}"

TRAVIS_REPO_SLUG="${TRAVIS_REPO_SLUG:-}"

endpoint="https://api.github.com/repos/${TRAVIS_REPO_SLUG}"

if [[ "${TRAVIS_BRANCH}" == "develop" ]]; then
  # Create new beta channel version
  releases=$(curl -s -H "Authorization: token ${GH_TOKEN}" ${endpoint}/releases)
  ver=$(jq --raw-output  ".version" app/package.json)
  rev="v${ver}"
  exists="1"
  cnt=1
  while [[ -n "${exists}" ]]; do
    rev="v0.0.1-beta.${cnt}"
    exists=$(echo ${releases} | jq --raw-output ".[] | select(.tag_name == \"${rev}\") | select(.draft == false)")
    let cnt++
  done
  rev=${rev:1}

  # Update config with new version
  beta_config=$(cat ./app/package.json | jq ".version = \"${rev}\"")
  mv ./app/package.json ./app/package.json.tmp
  echo "${beta_config}" > ./app/package.json
fi

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
  mkdir -p ./app/dist
  cp ./package.json ./src/main.js app/dist
  npm install
  ./node_modules/.bin/webpack --config ./config/webpack.electron.js  --progress --profile --colors --display-error-details --display-cached --bail
  ./node_modules/.bin/build -m

  if [[ "${TRAVIS_BRANCH}" == "develop" ]]; then
    ./node_modules/.bin/build -m -p always --prerelease
  fi

  if [[ "${TRAVIS_BRANCH}" == "master" ]]; then
    ./node_modules/.bin/build -m -p always
  fi
else
  docker build -t brisket .

  if [[ "${TRAVIS_BRANCH}" == "develop" ]]; then
    docker run --rm -it -e GH_TOKEN=${GH_TOKEN} brisket -lw -p always --prerelease
  fi

  if [[ "${TRAVIS_BRANCH}" == "master" ]]; then
    docker run --rm -it -e GH_TOKEN=${GH_TOKEN} brisket -lw -p always
  fi
fi

if [[ "${TRAVIS_BRANCH}" == "develop" ]]; then
  mv ./app/package.json.tmp ./app/package.json
fi
