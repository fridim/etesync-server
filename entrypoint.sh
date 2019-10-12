#!/bin/sh

set -xe

. /.venv/bin/activate

cd /data

if [ ! -z "$@" ]; then
    /manage.py "$@"
fi

if [ ! -e "${ETESYNC_SECRET}" ]; then
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > ${ETESYNC_SECRET}
fi

if [ ! -e "${ETESYNC_DB_PATH}" ]; then
    # first run
    /manage.py migrate
fi

/manage.py runserver 0.0.0.0:8000
