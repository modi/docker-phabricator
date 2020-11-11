FROM modicn/phabricator:eval

STOPSIGNAL SIGINT

COPY ./copy /

# https://github.com/phacility/phabricator/blob/stable/src/infrastructure/daemon/PhutilDaemonOverseer.php

CMD ["sh", "-c", "/code/phabricator/scripts/daemon/phd-daemon < /usr/local/etc/phabricator/phd-config.json"]

USER phab
