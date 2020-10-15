# docker build . -t modicn/phabricator:base && docker push modicn/phabricator:base

FROM php:7.3.23-fpm-alpine3.12

# --- Install bash, git, pygments

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        git \
        openssh-server \
        py-pygments \
        sudo

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

RUN ln -s /usr/local/bin/php /usr/bin/php

COPY ./copy /
