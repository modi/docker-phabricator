#!/bin/sh

VCSUSER="vcs"

ROOT="/code/phabricator"

if [ "$1" != "$VCSUSER" ];
then
  exit 1
fi

exec "$ROOT/bin/ssh-auth" $@
