#!/bin/sh

set -e

if [[ ! -e /etc/ssh/ssh_host_dsa_key ]]; then
    ssh-keygen -q -f /etc/ssh/ssh_host_dsa_key -t dsa -N ''
    ssh-keygen -q -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ''
    ssh-keygen -q -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''
    ssh-keygen -q -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''
fi

exec "$@"
