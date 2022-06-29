#!/bin/bash

#INSTALL DEPENDS COINS RUN

sudo apt update -y
sudo apt upgrade -y
sudo apt install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl git zip -y
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y

sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev openssl -y
sudo apt-get install libssl1.0-dev -y

#DOWNLOADING WALLET
wget https://github.com/BdcashProtocol/bdcashprotocol-bdeco/releases/download/V1.0.0.0/Binaries-Ubuntu18.zip
unzip Binaries-Ubuntu18.zip
chmod 777 bdcashprotocold
chmod 777 bdcashprotocol-cli
rm -r bdcashprotocol-tx
mv bdcashprotocold /usr/bin/bdcashprotocold
mv bdcashprotocol-cli /usr/bin/bdcashprotocol-cli
chmod 777 /usr/bin
rm -rf bin
rm Binaries-Ubuntu18.zip

#RUNNING WALLET FOR THE FIRST TIME
bdcashprotocold &
sleep 10s
pkill bdcashprotocold

#WRITING CONF FILE
echo "rpcuser=bdcashrpc
rpcpassword=bdcashpassword
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
rpcport=36264
listen=1
server=1
daemon=1
index=1
txindex=1
logtimestamps=1" > "/root/.bdcashprotocol/bdcashprotocol.conf"

#INSTALL NODEJS
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install pm2 -g

#INSTALL MONGODB
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update
sudo apt-get install -y mongodb
mkdir data
ulimit -n 1280000

#DOWNLOADING NODE MODULES
npm install
cp example.env .env
npm run build

#UPDATING NPM
npm install -g npm
npm install -g pm2
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 100M
pm2 set pm2-logrotate:compress true
pm2 set pm2-logrotate:rotateInterval '0 * * * *'

#SETTING UP FIREWALL
ufw allow 22
ufw deny 17292
ufw deny 27017
ufw allow 17293
ufw enable y

#SETTING UP NGINX
sudo apt update
sudo apt install nginx -y
sudo ufw allow 'Nginx Full'

#INSTALL CERTBOT
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt update
sudo apt install python-certbot-nginx -y

pm2 startup
node create_conf.js
echo "RUN THIS COMMAND TO RUN NODESH IN BACKGROUND:"
echo "pm2 start npm -- start && pm2 save"
echo ""
echo "RUN THIS COMMAND TO RUN NODESH IN FOREGROUND:"
echo "npm start"
