FROM modicn/phabricator:eval

COPY ./copy /

CMD ["sh", "-c", "/code/phabricator/scripts/daemon/phd-daemon < /usr/local/etc/phd-config.json"]
