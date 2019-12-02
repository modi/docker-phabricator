#!/bin/sh

set -e

cd /code/phabricator

./bin/config set mysql.host mysql
./bin/config set mysql.user root
./bin/config set mysql.pass root

./bin/storage upgrade --force

./bin/config set phabricator.base-uri "http://${PHAB_HOST}/"

./bin/config set phd.user phab
./bin/config set diffusion.ssh-user vcs
./bin/config set repository.default-local-path '/data/repos/'

./bin/config set storage.mysql-engine.max-size 0
./bin/config set storage.local-disk.path '/data/files/'

./bin/config set pygments.enabled true

./bin/config set security.outbound-blacklist '[]'
