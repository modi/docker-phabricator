# Usage:
# docker build . -t modicn/phabricator-noty:${PHAB_VER:-stable} && docker push modicn/phabricator-noty:${PHAB_VER:-stable}

FROM node:8-alpine

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash; \
    # @see https://github.com/nodejs/docker-node/issues/813
    npm config set unsafe-perm true; \
    npm install -g ws; \
    npm config set unsafe-perm false; \
    npm cache clean --force

ENV NODE_PATH /usr/local/lib/node_modules

RUN set -ex; \
    apk update; \
    apk add --no-cache git; \
    git clone --depth 1 --branch stable https://github.com/phacility/phabricator.git /tmp/phabricator; \
    apk del git; \
    mkdir -p /code/support; \
    cp -r /tmp/phabricator/support/aphlict /code/support/; \
    cp -r /tmp/phabricator/webroot /code/; \
    rm -rf /tmp/phabricator

COPY ./copy /

CMD ["node", "--max-old-space-size=256", "--", "/code/support/aphlict/server/aphlict_server.js", "--config=/usr/local/etc/aphlict-config.json"]
