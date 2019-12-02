#!/bin/sh

set -e

KEYS_LOCK="/data/SSH-HOST-KEYS-LOCK"
if [[ ! -e $KEYS_LOCK ]]; then
    KEYS_DIR="/data/secrets/sshd"

    if [[ ! -d $KEYS_DIR ]]; then
        mkdir -p $KEYS_DIR 
    fi

    ssh-keygen -q -f $KEYS_DIR/ssh_host_rsa_key -t rsa -N ''
    ssh-keygen -q -f $KEYS_DIR/ssh_host_dsa_key -t dsa -N ''
    ssh-keygen -q -f $KEYS_DIR/ssh_host_ecdsa_key -t ecdsa -N ''
    ssh-keygen -q -f $KEYS_DIR/ssh_host_ed25519_key -t ed25519 -N ''

    touch $KEYS_LOCK
fi

exec "$@"

