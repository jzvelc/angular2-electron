FROM electronuserland/electron-builder:wine

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
  git \
  && rm -rf /var/lib/apt/lists/*

