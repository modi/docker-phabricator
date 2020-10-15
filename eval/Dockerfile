# docker build . -t modicn/phabricator:eval && docker push modicn/phabricator:eval

FROM modicn/phabricator:base

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

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

COPY ./copy /

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
        /data/conf \
        /data/repos \
        /data/files \
        /data/phd \
        /data/sshd
    ; \
    echo '{}' > /data/conf/local.json; \
    ln -s /data/conf/local.json /code/phabricator/conf/local/local.json; \
    chown -R ${PHAB_UID}:${PHAB_GID} \
        /data/conf \
        /data/repos \
        /data/files \
        /data/phd \
        /code/phabricator/conf/local \
    ; \
    chown -R ${VCS_UID}:${VCS_GID} \
        /data/sshd

WORKDIR /code/phabricator
