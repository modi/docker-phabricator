#!/bin/sh

set -e

if [[ ! -d /data/ssh ]]; then
    mkdir /data/ssh
    ssh-keygen -q -f /data/ssh/ssh_host_dsa_key -t dsa -N ''
    ssh-keygen -q -f /data/ssh/ssh_host_ecdsa_key -t ecdsa -N ''
    ssh-keygen -q -f /data/ssh/ssh_host_ed25519_key -t ed25519 -N ''
    ssh-keygen -q -f /data/ssh/ssh_host_rsa_key -t rsa -N ''
fi

exec "$@"
