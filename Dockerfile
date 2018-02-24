# Etesync docker image
# https://github.com/etesync/server-skeleton.git

FROM alpine
MAINTAINER fridim fridim@onfi.re
EXPOSE 8000

ENV ETESYNC_DB_PATH /data/db.sqlite3
ENV ETESYNC_SECRET /data/secret

LABEL io.k8s.description="etesync server, self-hosted contacts and calendars" \
      io.k8s.display-name="etesync HEAD" \
      io.openshift.tags="etesync,contact,calendar" \
      name="etesync" \
      summary="The goal of this project is to make the easiest, fastest, and most painless way of setting up a self-hosted etesync service." \
      io.openshift.expose-services="8000,etesync"

RUN apk add -U git \
python \
py-pip \
sqlite

RUN pip install virtualenv

RUN git clone https://github.com/etesync/server-skeleton.git \
    && cd /server-skeleton \
    && virtualenv .venv \
    && source .venv/bin/activate \
    && pip install -r requirements.txt


# move the settings to /etc/etesync so it can be overwritten by a configmap
RUN mkdir /etc/etesync
COPY settings.py /etc/etesync
RUN rm /server-skeleton/etesync_server/settings.py \
&& ln -s /etc/etesync/settings.py /server-skeleton/etesync_server/settings.py

RUN apk del git && rm -rf /var/cache/apk/*
COPY entrypoint.sh /

RUN mkdir  /data && chmod 777 /data
VOLUME /data

CMD ["/entrypoint.sh"]
