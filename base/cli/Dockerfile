# Usage:
# docker build . -t modicn/phabricator:php-cli && docker push modicn/phabricator:php-cli

FROM php:7.3-cli-alpine

# Install extensions: opcache, pcntl, mysqli, zip, gd, apcu

ENV PHPIZE_DEPS "$PHPIZE_DEPS libzip-dev freetype-dev libpng-dev libjpeg-turbo-dev"

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        $PHPIZE_DEPS \
        libzip \
        freetype \
        libpng \
        libjpeg-turbo; \
    docker-php-ext-install \
        opcache \
        pcntl \
        mysqli; \
    docker-php-ext-configure zip --with-libzip; \
    docker-php-ext-install zip; \
    docker-php-ext-configure gd --with-freetype-dir --with-png-dir --with-jpeg-dir; \
    docker-php-ext-install gd; \
    pecl install \
        apcu-5.1.17; \
    docker-php-ext-enable \
        apcu; \
    rm -rf /tmp/pear; \
    apk del $PHPIZE_DEPS

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        git;

# Download Phabricator source code
RUN set -ex; \
    git clone --depth 1 --branch stable https://github.com/phacility/libphutil.git /code/libphutil; \
    rm -rf /code/libphutil/.git; \
    git clone --depth 1 --branch stable https://github.com/phacility/arcanist.git /code/arcanist; \
    rm -rf /code/arcanist/.git; \
    git clone --depth 1 --branch stable https://github.com/phacility/phabricator.git /code/phabricator; \
    rm -rf /code/phabricator/.git

# Add directory containing arc to $PATH
ENV PATH "$PATH:/code/arcanist/bin"
