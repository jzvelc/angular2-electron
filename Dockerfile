FROM electronuserland/electron-builder:wine

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
  git openssh-client \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

COPY ./package.json /project/package.json
COPY ./app/package.json /project/app/package.json

RUN npm install

COPY . /project
COPY ./package.json ./src/main.js /project/app/dist/

RUN ./node_modules/.bin/webpack --config ./config/webpack.electron.js --progress --profile --colors --display-error-details --display-cached --bail

ENTRYPOINT ["./node_modules/.bin/build"]
