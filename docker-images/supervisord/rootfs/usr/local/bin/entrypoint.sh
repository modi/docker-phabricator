#!/bin/sh

set -e

if [ ${1} = "phabricator" ]; then
    phabricator-install.sh

    if [[ ! -e /data/sshd/ssh_host_dsa_key ]]; then
        ssh-keygen -q -f /data/sshd/ssh_host_dsa_key -t dsa -N ''
    fi

    if [[ ! -e /data/sshd/ssh_host_ecdsa_key ]]; then
        ssh-keygen -q -f /data/sshd/ssh_host_ecdsa_key -t ecdsa -N ''
    fi

    if [[ ! -e /data/sshd/ssh_host_ed25519_key ]]; then
        ssh-keygen -q -f /data/sshd/ssh_host_ed25519_key -t ed25519 -N ''
    fi

    if [[ ! -e /data/sshd/ssh_host_rsa_key ]]; then
        ssh-keygen -q -f /data/sshd/ssh_host_rsa_key -t rsa -N ''
    fi

    exec /usr/bin/supervisord -c /etc/supervisord.conf
else
    exec "$@"
fi
