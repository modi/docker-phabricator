# export PHAB_VER=stable
# docker build . -f aphlict/Dockerfile -t mdxdm/phabricator-aphlict:${PHAB_VER} && docker push mdxdm/phabricator-aphlict:${PHAB_VER}

FROM node:8-alpine

RUN set -ex \
 && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
 && apk update \
 && apk add --no-cache \
        bash \
 && npm install -g ws \
 && npm cache clean --force

ENV NODE_PATH /usr/local/lib/node_modules

COPY ./code/phabricator/support/aphlict /code/phabricator/support/aphlict
COPY ./code/phabricator/webroot /code/phabricator/webroot
COPY ./aphlict/aphlict.json /usr/local/etc/aphlict.json

CMD ["node", "--max-old-space-size=256", "--", "/code/phabricator/support/aphlict/server/aphlict_server.js", "--config=/usr/local/etc/aphlict.json"]
