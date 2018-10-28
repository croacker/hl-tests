#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
VERSION=$1

# Restore version in package.json
# 
# IMPORTANT! For this script to work, you have to install "JSON": 
# npm i json -g
#
json -I -f package.json -e 'this.version="'"${VERSION}"'"'

# Remove old chaincode container in order to start a new one
# echo "Restarting Fabric..."
# sudo ~/fabric-tools/teardownFabric.sh
# sudo ~/fabric-tools/startFabric.sh
# ~/fabric-tools/createPeerAdminCard.sh
# Create archive
composer archive create -t dir -n .

# Install chaincode to peers
composer network install --card PeerAdmin@hlfv1 -a h-accounting@${VERSION}.bna -o npmrcFile=${SCRIPT_DIR}/npmConfig
# Start network. Create a new container with chaincode
composer network start --networkName h-accounting --networkVersion ${VERSION} --networkAdmin admin --networkAdminEnrollSecret adminpw --card PeerAdmin@hlfv1 --file networkadmin.card -o npmrcFile=${SCRIPT_DIR}/npmConfig

echo "Network admin card needs to be imported"
# Import network admin card
composer card import --file ${SCRIPT_DIR}/networkadmin.card


# Start a REST-server
nohup composer-rest-server -c admin@h-accounting -n never -w true --port 5000 &
