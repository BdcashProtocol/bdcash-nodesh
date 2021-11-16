#!/bin/bash

touch /opt/bdcash-idanodejs/.BOOTSTRAPPING
pkill lyrad
cd /opt/data/lyra
wget https://bs.bdcashchain.org/latest.zip
pkill lyrad
rm- -rf blocks chainstate database
unzip -o latest.zip
lyrad -datadir=/opt/data/lyra &
rm /opt/bdcash-idanodejs/.BOOTSTRAPPING