#!/usr/bin/env bash

set -x
set -o errexit
set -o nounset

apt-get update && apt-get install -yq jq

sawtooth keygen

STATUS_URL=$(intkey inc --url=http://rest-api-1:8008 something 4 | jq ".link" | sed -e 's/^"//' -e 's/"$//')
echo "-----------------------------------------------------------"
echo "WIll check on transaction at $STATUS_URL in 20 seconds"
echo "-----------------------------------------------------------"
sleep 30
curl $STATUS_URL