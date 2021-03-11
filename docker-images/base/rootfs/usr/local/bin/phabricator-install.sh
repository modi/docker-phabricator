#!/bin/sh

set -e

if ! TERM=dumb php -- <<'PINGDB'
<?php
error_reporting(E_ERROR);
$stderr = fopen('php://stderr', 'w');
fwrite($stderr, 'Connecting to MySQL...'."\n");
$maxTries = 10;
do {
    $mysql = new mysqli(getenv('PHA_DB_HOST'), getenv('PHA_DB_USER'), getenv('PHA_DB_PASS'));
    if ($mysql->connect_error) {
        fwrite($stderr, 'Retry in 3s...'."\n");
        --$maxTries;
        if ($maxTries <= 0) {
            fwrite($stderr, 'MySQL connection failed'."\n");
            exit(1);
        }
        sleep(3);
    }
} while ($mysql->connect_error);
$mysql->close();
PINGDB
then
    exit 1
fi

mkdir -p /data/conf /data/files /data/repos /data/sshd

if [[ ! -e /data/conf/local.json ]]; then
    echo '{}' > /data/conf/local.json
fi

chown -R pha-www:pha-www /data/conf /data/files
chown -R pha-phd:pha-phd /data/repos
setfacl -R -m u:pha-www:rwX -m u:pha-phd:rwX /data/files
setfacl -dR -m u:pha-www:rwX -m u:pha-phd:rwX /data/files

pha_dir=/code/phabricator

if [ ! -h "/code/phabricator/conf/local/local.json" ]; then
    ln -sf /data/conf/local.json $pha_dir/conf/local/local.json
fi

sudo -u pha-www $pha_dir/bin/config set mysql.host "${PHA_DB_HOST:-db}"
sudo -u pha-www $pha_dir/bin/config set mysql.user "${PHA_DB_USER:-root}"
sudo -u pha-www $pha_dir/bin/config set mysql.pass "${PHA_DB_PASS:-root}"

sudo -u pha-www $pha_dir/bin/storage upgrade --force

sudo -u pha-www $pha_dir/bin/config set phabricator.base-uri "${PHA_BASE_URI:-http://p.localhost:8181/}"

sudo -u pha-www $pha_dir/bin/config set phd.user pha-phd
sudo -u pha-www $pha_dir/bin/config set diffusion.ssh-user vcs
sudo -u pha-www $pha_dir/bin/config set diffusion.ssh-port ${PHA_SSH_PORT:-2222}
sudo -u pha-www $pha_dir/bin/config set repository.default-local-path '/data/repos/'
sudo -u pha-www $pha_dir/bin/config set diffusion.allow-http-auth true

sudo -u pha-www $pha_dir/bin/config set storage.mysql-engine.max-size 0
sudo -u pha-www $pha_dir/bin/config set storage.local-disk.path '/data/files/'

sudo -u pha-www $pha_dir/bin/config set pygments.enabled true

printf '[
    {
        "type": "client",
        "host": "%s",
        "port": %s,
        "protocol": "http"
    },
    {
        "type": "admin",
        "host": "aphlict",
        "port": 22281,
        "protocol": "http"
    }
]' "${PHA_APHLICT_CLIENT_HOST:-p.localhost}" "${PHA_APHLICT_CLIENT_PORT:-22280}" | sudo -u pha-www $pha_dir/bin/config set notification.servers --stdin
