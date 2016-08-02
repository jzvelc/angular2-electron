#!/bin/bash

set -euo pipefail

SWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CWD=$(cd "${SWD}" && cd .. && pwd)

TRAVIS_OS_NAME=osx

#rm -rf ./app/dist ./app/node_modules
#mkdir -p ./app/dist
cp package.json src/main.js app/dist

if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
  #npm install
  #webpack --config config/webpack.electron.js  --progress --profile --colors --display-error-details --display-cached --bail
  ./node_modules/.bin/build -m
else
  docker run --rm -it -v ${PWD}:/project -v brisket-node-modules:/project/node_modules brisket npm install
	docker run --rm -it -v ${PWD}:/project -v brisket-node-modules:/project/node_modules brisket webpack --config config/webpack.electron.js  --progress --profile --colors --display-error-details --display-cached --bail
	docker run --rm -it -v ${PWD}:/project -v brisket-node-modules:/project/node_modules brisket ./node_modules/.bin/build -l
fi
