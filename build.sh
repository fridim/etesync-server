#!/bin/sh
VERSION=${VERSION:-v0.0.2}

# Now build the Operator
docker build . -t quay.io/fridim/etesync-server:${VERSION}

docker push quay.io/fridim/etesync-server:${VERSION}
