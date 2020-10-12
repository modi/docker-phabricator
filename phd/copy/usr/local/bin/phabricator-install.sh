#!/bin/sh

set -e

cd /code/phabricator

./bin/config set mysql.host mysql
./bin/config set mysql.user root
./bin/config set mysql.pass root

if ! TERM=dumb php -- <<'EOPHP'
<?php

$stderr = fopen('php://stderr', 'w');

$maxTries = 10;
do {
    $mysql = new mysqli('mysql', 'root', 'root');
    if ($mysql->connect_error) {
        fwrite($stderr, "\n" . 'MySQL connection error: (' . $mysql->connect_errno . ') ' . $mysql->connect_error . "\n");
        --$maxTries;
        if ($maxTries <= 0) {
            fwrite($stderr, "\n" . 'MySQL connection failed'."\n");
            exit(1);
        }
        sleep(3);
    }
} while ($mysql->connect_error);

$mysql->close();
EOPHP
then
    exit 1
fi

./bin/storage upgrade --force

./bin/config set phabricator.base-uri "http://${PHAB_HOST}/"

./bin/config set phd.user phab
./bin/config set diffusion.ssh-user vcs
./bin/config set diffusion.ssh-port 2222
./bin/config set repository.default-local-path '/data/repos/'

./bin/config set storage.mysql-engine.max-size 0
./bin/config set storage.local-disk.path '/data/files/'

./bin/config set pygments.enabled true

./bin/config set security.outbound-blacklist '[]'
