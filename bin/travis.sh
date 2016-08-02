#!/bin/bash

set -euo pipefail

rm -rf ./app/dist ./app/node_modules
mkdir -p ./app/dist
cp ./package.json ./src/main.js app/dist

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
  npm install
  ./node_modules/.bin/webpack --config ./config/webpack.electron.js  --progress --profile --colors --display-error-details --display-cached --bail
  ./node_modules/.bin/build -m
else
  dev_node_modules_volume="./node_modules"
  app_node_modules_volume="./app/node_modules"

  if [[ -n "${DEBUG}" ]]; then
    dev_node_modules_volume="brisket-dev-node-modules"
    app_node_modules_volume="brisket-app-node-modules"
  fi

  docker build -t brisket .
  docker run --rm -it -v ${PWD}:/project -v ${dev_node_modules_volume}:/project/node_modules -v ${app_node_modules_volume}:/project/app/node_modules brisket npm install
	docker run --rm -it -v ${PWD}:/project -v ${dev_node_modules_volume}:/project/node_modules -v ${app_node_modules_volume}:/project/app/node_modules brisket ./node_modules/.bin/webpack --config ./config/webpack.electron.js --progress --profile --colors --display-error-details --display-cached --bail
	docker run --rm -it -v ${PWD}:/project -v ${dev_node_modules_volume}:/project/node_modules -v ${app_node_modules_volume}:/project/app/node_modules brisket ./node_modules/.bin/build -lw
fi

if [[ "${TRAVIS_BRANCH}" == "develop" ]]; then
  echo "develop"
fi

if [[ "${TRAVIS_BRANCH}" == "master" ]]; then
  echo "master"
fi
