FROM electronuserland/electron-builder:wine

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
  git openssh-client \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g webpack

RUN mkdir -p /root/.ssh
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
