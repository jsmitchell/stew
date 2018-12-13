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

sawadm keygen
sawadm keygen validator-2
sawadm keygen validator-3
sawadm keygen validator-4
sawadm keygen validator-5

VALIDATOR_1_PUBKEY=$(cat /etc/sawtooth/keys/validator.pub)
VALIDATOR_2_PUBKEY=$(cat /etc/sawtooth/keys/validator-2.pub)
VALIDATOR_3_PUBKEY=$(cat /etc/sawtooth/keys/validator-3.pub)
VALIDATOR_4_PUBKEY=$(cat /etc/sawtooth/keys/validator-4.pub)
VALIDATOR_5_PUBKEY=$(cat /etc/sawtooth/keys/validator-5.pub)
PEERS_JSON="[\"${VALIDATOR_1_PUBKEY}\",\"${VALIDATOR_2_PUBKEY}\",\"${VALIDATOR_3_PUBKEY}\",\"${VALIDATOR_4_PUBKEY}\",\"${VALIDATOR_5_PUBKEY}\"]"

sawset genesis \
    -k /etc/sawtooth/keys/validator.priv \
    -o config-genesis.batch

sawadm genesis config-genesis.batch config.batch

cp /etc/sawtooth/keys/* /shared_keys

echo $(cat /etc/sawtooth/keys/validator.pub)

sawtooth-validator -v \
    --endpoint ${VALIDATOR_1} \
    --bind component:${COMPONENT} \
    --bind consensus:${CONSENSUS} \
    --bind network:${NETWORK} \
    --peering static \
    --peers ${VALIDATOR_2},${VALIDATOR_3},${VALIDATOR_4},${VALIDATOR_5} \
    --scheduler parallel
