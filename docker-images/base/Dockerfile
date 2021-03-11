# docker build ./docker-images/base -t modicn/phabricator:base && docker push modicn/phabricator:base

FROM php:7.3.27-fpm-alpine3.12

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        acl \
        bash \
        git \
        git-daemon \
        mercurial \
        procps \
        py-pygments \
        subversion \
        sudo \
    ; \
    rm -rf /var/cache/apk/*

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
        apcu \
    ; \
    docker-php-ext-enable \
        apcu \
    ; \
    rm -rf /tmp/pear; \
    apk del $PHPIZE_DEPS; \
    rm -rf /var/cache/apk/*

RUN set -ex; \
    ln -s /usr/local/bin/php /usr/bin/php; \
    ln -s /usr/libexec/git-core/git-http-backend /usr/bin/git-http-backend

# https://github.com/phacility/phabricator
ARG PHABRICATOR_COMMIT=e7d3bae2cc3fb5f462a6304dd0c243740442cdf9
# https://github.com/phacility/arcanist
ARG ARCANIST_COMMIT=7ad4afb9190bf4ca86dbf19047ca627dafeaac1f
# https://github.com/PHPOffice/PHPExcel
ARG PHPEXCEL_VER=1.8.2

RUN set -ex; \
    apk update; \
    apk add --no-cache \
        unzip \
    ; \
    mkdir /code; \
    mkdir /code/phabricator; \
    git -C /code/phabricator init; \
    git -C /code/phabricator remote add origin https://github.com/phacility/phabricator.git; \
    git -C /code/phabricator fetch --depth 1 origin ${PHABRICATOR_COMMIT}; \
    git -C /code/phabricator -c advice.detachedHead=false checkout FETCH_HEAD; \
    mkdir /code/arcanist; \
    git -C /code/arcanist init; \
    git -C /code/arcanist remote add origin https://github.com/phacility/arcanist.git; \
    git -C /code/arcanist fetch --depth 1 origin ${ARCANIST_COMMIT}; \
    git -C /code/arcanist -c advice.detachedHead=false checkout FETCH_HEAD; \
    ln -s /code/arcanist/bin/arc /usr/local/bin/arc; \
    mkdir /tmp/download; \
    wget -O /tmp/download/phpexcel.zip -q https://github.com/PHPOffice/PHPExcel/archive/${PHPEXCEL_VER}.zip; \
    unzip -d /code -q /tmp/download/phpexcel.zip; \
    mv /code/PHPExcel-${PHPEXCEL_VER} /code/phpexcel; \
    wget -O /code/phabricator/src/extensions/PhabricatorSimplifiedChineseTranslation.php -q "https://github.com/arielyang/phabricator_zh_Hans/raw/master/dist/(stable)%20Promote%202020%20Week%2037/PhabricatorSimplifiedChineseTranslation.php"; \
    rm -rf /tmp/download; \
    apk del unzip; \
    rm -rf /var/cache/apk/*

ARG WWW_USER=pha-www
ARG WWW_GID=10000
ARG WWW_UID=10000
ARG PHD_USER=pha-phd
ARG PHD_GID=10001
ARG PHD_UID=10001
ARG VCS_USER=vcs
ARG VCS_GID=10002
ARG VCS_UID=10002

RUN set -ex; \
    if [ -z "`getent group $WWW_GID`" ]; then \
        addgroup -S -g $WWW_GID $WWW_USER; \
    fi; \
    adduser -S -D -u $WWW_UID -G `getent group $WWW_GID | cut -d: -f1` $WWW_USER; \
    if [ -z "`getent group $PHD_GID`" ]; then \
        addgroup -S -g $PHD_GID $PHD_USER; \
    fi; \
    adduser -S -D -u $PHD_UID -G `getent group $PHD_GID | cut -d: -f1` $PHD_USER; \
    if [ -z "`getent group $VCS_GID`" ]; then \
        addgroup -g $VCS_GID $VCS_USER; \
    fi; \
    adduser -D -u $VCS_UID -G `getent group $VCS_GID | cut -d: -f1` $VCS_USER; \
    passwd -u $VCS_USER; \
    echo "$WWW_USER ALL=($PHD_USER) SETENV: NOPASSWD: /usr/bin/git, /usr/bin/git-upload-pack, /usr/bin/git-receive-pack, /usr/libexec/git-core/git-http-backend, /usr/bin/svnserve, /usr/bin/hg" >> /etc/sudoers; \
    echo "$VCS_USER ALL=($PHD_USER) SETENV: NOPASSWD: /usr/bin/git, /usr/bin/git-upload-pack, /usr/bin/git-receive-pack, /usr/libexec/git-core/git-http-backend, /usr/bin/svnserve, /usr/bin/hg" >> /etc/sudoers

RUN set -ex; \
    mkdir -p /data/conf; \
    ln -sf /data/conf/local.json /code/phabricator/conf/local/local.json

VOLUME /data

COPY ./rootfs /
