#!/bin/bash

set -euo pipefail

GH_TOKEN="${GH_TOKEN:-}"

TRAVIS_REPO_SLUG="${TRAVIS_REPO_SLUG:-}"

endpoint="https://api.github.com/repos/jzvelc/angular2-electron"

releases=$(curl -s -H "Authorization: token ${GH_TOKEN}" ${endpoint}/releases)

#tags=($(echo ${releases} | jq --raw-output ".[] | select(.draft == false) | .tag_name"))


echo ${releases} | jq --raw-output ".[] | select(.tag_name == \"v0.0.1-beta3\") |  select(.draft == false)"

