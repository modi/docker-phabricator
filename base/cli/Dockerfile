# docker build . -t modicn/phabricator:base-cli && docker push modicn/phabricator:base-cli

FROM php:7.3-cli-alpine

# Install bash, git, pygments
RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        git \
        py-pygments

# Install PHP extensions: apcu, gd, mysqli, opcache, pcntl, zip
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
    docker-php-ext-configure gd --with-freetype-dir --with-png-dir --with-jpeg-dir; \
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

# Download Phabricator source code
RUN set -ex; \
    git clone --depth 1 --branch stable https://github.com/phacility/libphutil.git /code/libphutil; \
    rm -rf /code/libphutil/.git; \
    git clone --depth 1 --branch stable https://github.com/phacility/phabricator.git /code/phabricator; \
    rm -rf /code/phabricator/.git; \
    git clone --depth 1 --branch stable https://github.com/phacility/arcanist.git /code/arcanist; \
    rm -rf /code/arcanist/.git; \
    ln -s /code/arcanist/bin/arc /usr/local/bin/arc

WORKDIR /code/phabricator
