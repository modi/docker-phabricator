# docker build ./docker-images/supervisord -t modicn/phabricator:supervisord && docker push modicn/phabricator:supervisord

FROM alpine:3.12

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        npm \
    ; \
    npm install -g ws; \
    apk del npm

FROM modicn/phabricator:base

ENV NODE_PATH /usr/lib/node_modules

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        nodejs \
        openssh-server \
        supervisor \
    ; \
    apk add --no-cache nginx; \
    addgroup nginx www-data; \
    mkdir /run/nginx; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log; \
    rm -rf /var/cache/apk/*

RUN set -ex; \
    addgroup -S -g 11000 aphlict; \
    adduser -S -D -u 11000 -G aphlict aphlict

COPY ./rootfs /

COPY --from=0 /usr/lib/node_modules /usr/lib/node_modules

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

WORKDIR /code/phabricator

ENTRYPOINT ["entrypoint.sh"]

CMD ["phabricator"]
