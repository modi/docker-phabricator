# docker build ./docker-images/aphlict -t modicn/phabricator:aphlict && docker push modicn/phabricator:aphlict

FROM node:8-alpine

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
    addgroup -S -g 11000 aphlict; \
    adduser -S -D -u 11000 -G aphlict aphlict

COPY ./rootfs /

COPY --from=modicn/phabricator:base /code/phabricator/support/aphlict /code/support/aphlict

COPY --from=modicn/phabricator:base /code/phabricator/webroot /code/webroot

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["node", "--max-old-space-size=256", "--", "/code/support/aphlict/server/aphlict_server.js", "--config=/usr/local/etc/phabricator/aphlict.json"]

USER aphlict
