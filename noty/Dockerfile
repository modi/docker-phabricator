# docker build . -t modicn/phabricator:noty && docker push modicn/phabricator:noty

FROM node:8-alpine

ARG COMMIT_HASH=5e06d924f8eba5df354c690ceb693e454e965d16

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        tini \
    ; \
    rm -rf /var/cache/apk/*; \
    # @see https://github.com/nodejs/docker-node/issues/813
    npm config set unsafe-perm true; \
    npm install -g ws; \
    npm config set unsafe-perm false; \
    npm cache clean --force

ENV NODE_PATH /usr/local/lib/node_modules

RUN set -ex; \
    mkdir /tmp/download; \
    wget -O /tmp/download/phabricator.zip -q https://github.com/phacility/phabricator/archive/${COMMIT_HASH}.zip; \
    unzip -d /tmp/download -q /tmp/download/phabricator.zip; \
    mkdir -p /code/support; \
    cp -r /tmp/download/phabricator-${COMMIT_HASH}/support/aphlict /code/support/; \
    cp -r /tmp/download/phabricator-${COMMIT_HASH}/webroot /code/; \
    rm -rf /tmp/download

COPY ./copy /

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["node", "--max-old-space-size=256", "--", "/code/support/aphlict/server/aphlict_server.js", "--config=/usr/local/etc/phabricator/aphlict-config.json"]
