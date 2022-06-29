#!/bin/bash

if [[ $1 == "-testnet" ]]
then
    echo "Running BdcashProtocol NodeSh in testnet mode"
    pkill bdcashprotocold
    npm run build
    npm run start:testnet
else
    echo "Running BdcashProtocol NodeSh in mainnet mode"
    pkill /root//bdcashprotocold
    npm run build
    npm run start
fi
