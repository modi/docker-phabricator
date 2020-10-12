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

RUN set -ex; \
    mkdir /code /tmp/download; \
    wget -O /tmp/download/phabricator.zip -q https://github.com/phacility/phabricator/archive/5e06d924f8eba5df354c690ceb693e454e965d16.zip; \
    unzip -d /code -q /tmp/download/phabricator.zip; \
    mv /code/phabricator-5e06d924f8eba5df354c690ceb693e454e965d16 /code/phabricator; \
    wget -O /tmp/download/arcanist.zip -q https://github.com/phacility/arcanist/archive/68dba1a2c6d9fe1de7b9d4c944336458d0f016b3.zip; \
    unzip -d /code -q /tmp/download/arcanist.zip; \
    mv /code/arcanist-68dba1a2c6d9fe1de7b9d4c944336458d0f016b3 /code/arcanist; \
    ln -s /code/arcanist/bin/arc /usr/local/bin/arc; \
    wget -O /tmp/download/phpexcel.zip -q https://github.com/PHPOffice/PHPExcel/archive/1.8.2.zip; \
    unzip -d /code -q /tmp/download/phpexcel.zip; \
    wget -O /code/phabricator/src/extensions/PhabricatorSimplifiedChineseTranslation.php -q "https://github.com/arielyang/phabricator_zh_Hans/raw/master/dist/(stable)%20Promote%202020%20Week%2037/PhabricatorSimplifiedChineseTranslation.php"; \
    rm -rf /tmp/download

COPY ./copy /
