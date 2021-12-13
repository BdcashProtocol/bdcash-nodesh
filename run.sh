#!/bin/bash

if [[ $1 == "-testnet" ]]
then
    echo "Running Bdcash NodeSh in testnet mode"
    pkill bdcashd
    npm run build
    npm run start:testnet
else
    echo "Running Bdcash NodeSh in mainnet mode"
    pkill /root//bdcashd
    npm run build
    npm run start
fi
