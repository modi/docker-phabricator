# docker build . -t modicn/phabricator:base-fpm && docker push modicn/phabricator:base-fpm

FROM php:7.3.23-fpm-alpine3.12

# --- Install bash, git, pygments

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        git \
        py-pygments

# --- Install PHP extensions: apcu, gd, mysqli, opcache, pcntl, zip

ENV PHPIZE_DEPS "$PHPIZE_DEPS freetype-dev libjpeg-turbo-dev libpng-dev libzip-dev"

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        $PHPIZE_DEPS \
        # gd
        freetype \
        libjpeg-turbo \
        libpng \
        # zip
        libzip \
    ; \
    docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir --with-png-dir; \
    docker-php-ext-install gd; \
    docker-php-ext-configure zip --with-libzip; \
    docker-php-ext-install zip; \
    docker-php-ext-install \
        mysqli \
        opcache \
        pcntl \
    ; \
    pecl install \
        apcu-5.1.18 \
    ; \
    docker-php-ext-enable \
        apcu \
    ; \
    rm -rf /tmp/pear; \
    apk del $PHPIZE_DEPS

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini; \
    ln -s /usr/local/bin/php /usr/bin/php

COPY --from=modicn/phabricator:2020.37-code /code/ /code/
COPY ./copy /

