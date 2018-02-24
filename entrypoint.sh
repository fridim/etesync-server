#!/bin/sh

set -xe

. /server-skeleton/.venv/bin/activate

cd /data

if [ ! -z "$@" ]; then
    /server-skeleton/manage.py "$@"
fi

if [ ! -e "${ETESYNC_SECRET}" ]; then
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > ${ETESYNC_SECRET}
fi

if [ ! -e "${ETESYNC_DB_PATH}" ]; then
    # first run
    /server-skeleton/manage.py migrate
fi

/server-skeleton/manage.py runserver 0.0.0.0:8000
