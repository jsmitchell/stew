#!/usr/bin/env bash

set -o errexit
set -o nounset

COMPONENT=tcp://eth0:4004
CONSENSUS=tcp://eth0:5050
NETWORK=tcp://eth0:8800

VALIDATOR_1=tcp://validator-1:8800
VALIDATOR_2=tcp://validator-2:8800
VALIDATOR_3=tcp://validator-3:8800
VALIDATOR_4=tcp://validator-4:8800
VALIDATOR_5=tcp://validator-5:8800

while true; do
    if [ -e /shared_keys/validator-2.pub ]; then
        cp /shared_keys/validator-2.priv /etc/sawtooth/keys/validator.priv
        cp /shared_keys/validator-2.pub /etc/sawtooth/keys/validator.pub
        break
    fi
    sleep 0.5
done

echo $(cat /etc/sawtooth/keys/validator.pub)

sawtooth-validator -v \
    --endpoint ${VALIDATOR_2} \
    --bind component:${COMPONENT} \
    --bind consensus:${CONSENSUS} \
    --bind network:${NETWORK} \
    --peering static \
    --peers ${VALIDATOR_1},${VALIDATOR_3},${VALIDATOR_4},${VALIDATOR_5} \
    --scheduler parallel
