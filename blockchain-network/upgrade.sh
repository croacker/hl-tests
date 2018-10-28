#!/bin/bash
SCRIPT_DIR=$(dirname "$0")

# Increment version in package.json
# 
# IMPORTANT! For this script to work, you have to install "JSON": 
# npm i json -g
#
VERSION=$(cat package.json | json version)
VERSION_PREFIX=$(echo ${VERSION} | cut -d '.' -f 1-2)
MINOR_VERSION=$(echo ${VERSION} | cut -d '.' -f 3)
NEW_MINOR_VERSION=$((++MINOR_VERSION))
NEW_VERSION=${VERSION_PREFIX}.${NEW_MINOR_VERSION}
json -I -f package.json -e 'this.version="'"${NEW_VERSION}"'"'


composer archive create --sourceType dir --sourceName . -a h-accounting@${NEW_VERSION}.bna
composer network install --card PeerAdmin@hlfv1 --archiveFile h-accounting@${NEW_VERSION}.bna -o npmrcFile=${SCRIPT_DIR}/npmConfig
composer network upgrade -c PeerAdmin@hlfv1 -n h-accounting -V ${NEW_VERSION} -o npmrcFile=${SCRIPT_DIR}/npmConfig

# Start a REST-server
nohup composer-rest-server -c admin@h-accounting -n never -w true --port 5000 &