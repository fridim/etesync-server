#!/bin/sh

set -xe

. /server/.venv/bin/activate

cd /data

if [ ! -z "$@" ]; then
    /server/manage.py "$@"
fi

if [ ! -e "${ETESYNC_SECRET}" ]; then
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > ${ETESYNC_SECRET}
fi

if [ ! -e "${ETESYNC_DB_PATH}" ]; then
    # first run
    /server/manage.py migrate
fi

/server/manage.py runserver 0.0.0.0:8000
