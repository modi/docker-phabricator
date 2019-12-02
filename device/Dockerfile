# Usage:
# docker build . --build-arg PHAB_UID=${PHAB_UID:-1000} --build-arg PHAB_GID=${PHAB_GID:-1000} -t modicn/phabricator-device:${PHAB_VER:-stable} && docker push modicn/phabricator-device:${PHAB_VER:-stable}

FROM modicn/phabricator-php:fpm

ARG PHAB_UID=1000
ARG PHAB_GID=1000
ARG VCS_UID=2000
ARG VCS_GID=2000

# Install system requirements
RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        git \
        openssh-server \
        py-pygments \
        sudo \
        supervisor

# Add config files & scripts
COPY ./copy /

# Use PHP.ini settings recommended for production
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# Set up user `phab` for running PHP-FPM workers and Phabricator phd daemons
RUN set -ex; \
    if [ -z "`getent group ${PHAB_GID}`" ]; then \
        addgroup -S -g ${PHAB_GID} phab; \
    fi; \
    adduser -S -D -u ${PHAB_UID} -G `getent group ${PHAB_GID} | cut -d: -f1` phab; \
    { \
        echo '[www]'; \
        echo "user = ${PHAB_UID}"; \
        echo "group = ${PHAB_GID}"; \
    } > /usr/local/etc/php-fpm.d/zz-phabricator.conf

# Set up user `vcs` for git transport over ssh
RUN set -ex; \
    if [ -z "`getent group ${VCS_GID}`" ]; then \
        addgroup -S -g ${VCS_GID} vcs; \
    fi; \
    adduser -S -D -u ${VCS_UID} -G `getent group ${VCS_GID} | cut -d: -f1` -s /bin/ash vcs; \
    passwd -u vcs; \
    echo 'vcs ALL=(phab) SETENV: NOPASSWD: /usr/bin/git, /usr/bin/git-upload-pack, /usr/bin/git-receive-pack' >> /etc/sudoers

# Download Phabricator source code
RUN set -ex; \
    git clone --depth 1 --branch stable https://github.com/phacility/libphutil.git /code/libphutil; \
    rm -rf /code/libphutil/.git; \
    git clone --depth 1 --branch stable https://github.com/phacility/arcanist.git /code/arcanist; \
    rm -rf /code/arcanist/.git; \
    git clone --depth 1 --branch stable https://github.com/phacility/phabricator.git /code/phabricator; \
    rm -rf /code/phabricator/.git

# Add directory containing arc to PATH
ENV PATH "$PATH:/code/arcanist/bin"

# 创建数据目录，保存代码仓库、文件、SSH 主机证书等
RUN mkdir -p /data/repos \
 && mkdir -p /data/file \
 && chown -R ${PHAB_UID}:${PHAB_GID} /data/*

# 创建 phd 工作目录
RUN mkdir -p /run/phd/pid \
 && mkdir -p /run/phd/log \
 && chown -R ${PHAB_UID}:${PHAB_GID} /run/phd

ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR /code/phabricator

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
