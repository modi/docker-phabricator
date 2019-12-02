# Usage:
# docker build . --build-arg PHAB_UID=${PHAB_UID:-1000} --build-arg PHAB_GID=${PHAB_GID:-1000} -t modicn/phabricator-web:${PHAB_VER:-stable} && docker push modicn/phabricator-web:${PHAB_VER:-stable}

FROM modicn/phabricator:php-fpm

ARG PHAB_UID=1000
ARG PHAB_GID=1000
ARG VCS_UID=2000
ARG VCS_GID=2000

# Set up user `phab` for running PHP-FPM workers and Phabricator phd daemons
RUN set -ex; \
    if [ -z "`getent group ${PHAB_GID}`" ]; then \
        addgroup -S -g ${PHAB_GID} phab; \
    fi; \
    adduser -S -D -u ${PHAB_UID} -G `getent group ${PHAB_GID} | cut -d: -f1` phab

RUN mkdir -p /data/repos; \
    mkdir -p /data/files; \
    mkdir -p /run/phd; \
    chown -R ${PHAB_UID}:${PHAB_GID} \
        /data/* \
        /run/phd \
        /code/phabricator/conf/local

COPY ./copy /

# Use PHP.ini settings recommended for production
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

WORKDIR /code/phabricator

USER phab
