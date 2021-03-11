# docker build ./docker-images/phd -t modicn/phabricator:phd && docker push modicn/phabricator:phd

FROM modicn/phabricator:base

COPY ./rootfs /

STOPSIGNAL SIGINT

ENTRYPOINT []

# https://github.com/phacility/phabricator/blob/stable/src/infrastructure/daemon/PhutilDaemonOverseer.php
CMD ["/bin/sh", "-c", "/code/phabricator/scripts/daemon/phd-daemon < /usr/local/etc/phabricator/phd.json"]

USER pha-phd
