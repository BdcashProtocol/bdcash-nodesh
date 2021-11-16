#!/bin/bash

if [[ $1 == "-testnet" ]]
then
    echo "Running Bdcash IdaNode in testnet mode"
    pkill lyrad
    npm run build
    npm run start:testnet
else
    echo "Running Bdcash IdaNode in mainnet mode"
    pkill lyrad
    npm run build
    npm run start
fi