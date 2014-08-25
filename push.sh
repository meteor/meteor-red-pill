#!/bin/bash

set -e
set -u
set -x

if [ -z "$VERSION" ]; then
    echo "Must set the fake redpill's tool version VERSION."
    exit 1
fi

if [ -z "${RELEASE_VERSION}" ]; then
    echo "Must set the release name (eg 0.9.0) with RELEASE_VERSION."
    exit 1
fi

START="s3://meteor-warehouse/tools/$VERSION/meteor-tools-$VERSION"
tar czvf meteor-tools-$VERSION-Darwin_x86_64.tar.gz fake-tool/bin/meteor
s3cmd -P put meteor-tools-$VERSION-Darwin_x86_64.tar.gz s3://meteor-warehouse/tools/$VERSION/
s3cmd -P cp "$START-Darwin_x86_64.tar.gz" "$START-Linux_x86_64.tar.gz"
s3cmd -P cp "$START-Darwin_x86_64.tar.gz" "$START-Linux_i686.tar.gz"

cp release.json ${RELEASE_VERSION}.release.json
s3cmd -P put ${RELEASE_VERSION}.release.json s3://meteor-warehouse/releases/
rm ${RELEASE_VERSION}.release.json

cp release.json METEOR@${RELEASE_VERSION}.release.json
s3cmd -P put METEOR@${RELEASE_VERSION}.release.json s3://meteor-warehouse/releases/
rm METEOR@${RELEASE_VERSION}.release.json
