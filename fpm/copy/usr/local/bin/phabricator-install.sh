#!/bin/sh

set -e

cd /code/phabricator

./bin/config set mysql.host mysql
./bin/config set mysql.user root
./bin/config set mysql.pass root

if ! TERM=dumb php -- <<'EOPHP'
<?php

error_reporting(E_ERROR);

$stderr = fopen('php://stderr', 'w');
fwrite($stderr, 'Connecting to MySQL...'."\n");

$maxTries = 10;
do {
    $mysql = new mysqli('mysql', 'root', 'root');
    if ($mysql->connect_error) {
        fwrite($stderr, 'Retry in 5s...'."\n");
        --$maxTries;
        if ($maxTries <= 0) {
            fwrite($stderr, 'MySQL connection failed'."\n");
            exit(1);
        }
        sleep(5);
    }
} while ($mysql->connect_error);

$mysql->close();
EOPHP
then
    exit 1
fi

./bin/storage upgrade --force

./bin/config set phabricator.base-uri "http://${PHAB_HOST}:${PHAB_WEB_PORT}/"

./bin/config set phd.user phab
./bin/config set diffusion.ssh-user vcs
./bin/config set diffusion.ssh-port ${PHAB_SSH_PORT}
./bin/config set repository.default-local-path '/data/repos/'

./bin/config set storage.mysql-engine.max-size 0
./bin/config set storage.local-disk.path '/data/files/'

./bin/config set pygments.enabled true

./bin/config set security.outbound-blacklist '[]'

printf '[
    {
        "type": "client",
        "host": "%s",
        "port": 22280,
        "protocol": "http"
    },
    {
        "type": "admin",
        "host": "noty",
        "port": 22281,
        "protocol": "http"
    }
]' "$PHAB_HOST" | ./bin/config set notification.servers --stdin
