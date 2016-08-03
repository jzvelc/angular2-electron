#!/bin/bash

TRAVIS_REPO_SLUG="jzvelc/angular2-electron"


endpoint="https://api.github.com/repos/${TRAVIS_REPO_SLUG}"

TRAVIS_BRANCH="develop"


rev=""
if [[ "${TRAVIS_BRANCH}" == "develop" ]]; then
  releases=$(curl -s -H "Authorization: token ${GH_TOKEN}" ${endpoint}/releases)
  tags=($(echo ${releases} | jq --raw-output ".[].tag_name"))
  ver=$(jq --raw-output  ".version" app/package.json)
  exists="1"
  cnt=1
  while [[ -n "${exists}" ]]; do
    rev="v0.0.1-beta${cnt}"
    exists=$(echo ${releases} | jq --raw-output ".[] | select(.tag_name == \"${rev}\")")
    let cnt++
  done
fi

rev=${rev:1}



output=$(cat ./app/package.json | jq ".version = \"${rev}\"")
mv ./app/package.json ./app/package.json.tmp
echo "${output}" > ./app/package.json
mv ./app/package.json.tmp ./app/package.json

#echo "${pkg}" > ./app/package.json
#
#cat ./app/package.json
#releases=$(curl -s -H "Authorization: token ${GH_TOKEN}" https://api.github.com/repos/jzvelc/angular2-electron/releases)
#tags=($(echo ${releases} | jq --raw-output ".[].tag_name"))
#ver=$(jq --raw-output  ".version" app/package.json)
#rev=${ver}
#exists="1"
#cnt=1
#while [[ -n "${exists}" ]]; do
#  rev="v0.0.1-beta${cnt}"
#  exists=$(echo ${releases} | jq --raw-output ".[] | select(.tag_name == \"${rev}\")")
#  let cnt++
#done
#echo $rev
#echo $ver

#echo $releases
#exists=$(echo ${releases} | jq --raw-output '.[] | select(.tag_name == "${rev}")')
#echo $exists

#
#for item in "${tags[@]}"; do
#  if [[ "${rev}" == "${item}" ]]; then
#    echo "present in the array"
#  fi
#done
