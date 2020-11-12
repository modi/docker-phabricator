FROM modicn/phabricator:base

ARG PHAB_UID=1000
ARG PHAB_GID=1000
ARG VCS_UID=2000
ARG VCS_GID=2000

RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

COPY ./copy /

# Set up user `phab` for running PHP-FPM workers and Phabricator phd daemons
RUN set -ex; \
    if [ -z "`getent group ${PHAB_GID}`" ]; then \
        addgroup -S -g ${PHAB_GID} phab; \
    fi; \
    adduser -S -D -u ${PHAB_UID} -G `getent group ${PHAB_GID} | cut -d: -f1` phab

# Set up user `vcs` for git transport over ssh
RUN set -ex; \
    if [ -z "`getent group ${VCS_GID}`" ]; then \
        addgroup -S -g ${VCS_GID} vcs; \
    fi; \
    adduser -S -D -u ${VCS_UID} -G `getent group ${VCS_GID} | cut -d: -f1` -s /bin/ash vcs; \
    passwd -u vcs; \
    echo 'vcs ALL=(phab) SETENV: NOPASSWD: /usr/bin/git, /usr/bin/git-upload-pack, /usr/bin/git-receive-pack' >> /etc/sudoers

RUN set -ex; \ 
    mkdir -p \
        /data/repos \
        /data/files \
        /data/sshd \
    ; \
    chown -R ${PHAB_UID}:${PHAB_GID} \
        /data/repos \
        /data/files \
    ; \
    chown -R ${VCS_UID}:${VCS_GID} \
        /data/sshd

VOLUME /data

WORKDIR /code/phabricator
