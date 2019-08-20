# export PHAB_UID=1000
# export PHAB_GID=1000
# export PHAB_VER=stable
# docker build . --build-arg PHAB_UID=${PHAB_UID} --build-arg PHAB_GID=${PHAB_GID} -f phabricator/Dockerfile -t mdxdm/phabricator:${PHAB_VER} && docker push mdxdm/phabricator:${PHAB_VER}

FROM mdxdm/phabricator-php:latest

ARG PHAB_UID=1000
ARG PHAB_GID=1000
ARG VCS_UID=2000
ARG VCS_GID=2000

# 安装系统依赖
RUN set -ex \
 && apk update \
 && apk add --no-cache \
        bash \
        git \
        openssh-server \
        py-pygments \
        sudo \
        supervisor

# PHP 配置
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
COPY ./phabricator/php.ini /usr/local/etc/php/conf.d/zz-phabricator.ini

# 创建 phab 用户，用于运行 PHP-FPM 工作进程和 phd
# - https://secure.phabricator.com/book/phabricator/article/managing_daemons/
RUN set -ex \
 && if [ -z "`getent group ${PHAB_GID}`" ]; then \
        addgroup -S -g ${PHAB_GID} phab; \
    fi \
 && adduser -S -D -u ${PHAB_UID} -G `getent group ${PHAB_GID} | cut -d: -f1` phab \
 && { \
        echo '[www]'; \
        echo "user = ${PHAB_UID}"; \
        echo "group = ${PHAB_GID}"; \
    } > /usr/local/etc/php-fpm.d/zz-phabricator.conf

COPY ./phabricator/phd-config.json /usr/local/etc/phd-config.json

# 创建 vcs 用户，用于代码仓库 SSH 传输服务
# - https://secure.phabricator.com/book/phabricator/article/diffusion_hosting/#sshd-setup
RUN set -ex \
 && if [ -z "`getent group ${VCS_GID}`" ]; then \
        addgroup -S -g ${VCS_GID} vcs; \
    fi \
 && adduser -S -D -u ${VCS_UID} -G `getent group ${VCS_GID} | cut -d: -f1` -s /bin/ash vcs \
 && passwd -u vcs \
 && echo 'vcs ALL=(phab) SETENV: NOPASSWD: /usr/bin/git, /usr/bin/git-upload-pack, /usr/bin/git-receive-pack' >> /etc/sudoers

# SSH 传输服务
COPY ./phabricator/sshd_config /etc/ssh/sshd_config

COPY ./phabricator/phabricator-ssh-hook.sh /usr/local/bin/phabricator-ssh-hook.sh
RUN chmod 755 /usr/local/bin/phabricator-ssh-hook.sh \
 && ln -s /usr/local/bin/php /usr/bin/php

# Supervisor
COPY ./phabricator/supervisord.conf /etc/supervisord.conf

# 应用的配置初始化脚本
COPY ./phabricator/phabricator-init.sh /usr/local/bin/phabricator-init.sh
RUN chmod +x /usr/local/bin/phabricator-init.sh

# 添加应用源代码
COPY --chown=${PHAB_UID}:${PHAB_GID} ./code /code
ENV PATH "$PATH:/code/arcanist/bin"

# 创建应用的工作目录，保存代码仓库、文件、pid 文件及日志等
RUN mkdir -p /storage/repos \
 && mkdir -p /storage/file \
 && chown -R ${PHAB_UID}:${PHAB_GID} /storage/* \
 && mkdir -p /var/tmp/phd/pid \
 && mkdir -p /var/tmp/phd/log \
 && chown -R ${PHAB_UID}:${PHAB_GID} /var/tmp/phd

VOLUME /storgae
VOLUME /code/phabricator/conf/local

COPY ./phabricator/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

WORKDIR /code/phabricator

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
