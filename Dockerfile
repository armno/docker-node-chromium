FROM node:10.15.0-alpine

RUN apk update && apk upgrade \
  echo @edge "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo @edge "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo @edge "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk --no-cache update \
  && apk --no-cache upgrade \
  && apk add --no-cache --virtual .gyp python make g++ \
  && apk add --no-cache chromium@edge \
  && rm -rf /var/lib/apt/lists/* \
  /var/cache/apk/* \
  /usr/share/man \
  /tmp/*

ENV CHROME_BIN=/usr/bin/chromium-browser \
  CHROME_PATH=/usr/lib/chromium/
