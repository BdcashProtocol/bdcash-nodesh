#!/bin/bash

#DOWNLOADING WALLET
wget https://github.com/BdcashProtocol/bdcash-protocol/releases/download/v2.0.0.0-bdcashprotocol/BDCash-Protocol-BinariesV2-0-ubuntu18.zip
unzip BDCash-Protocol-BinariesV2-0-ubuntu18.zip
chmod 777 bdcashd
chmod 777 bdcash-cli
rm -r bdcash-tx
mv bdcashd /usr/bin/bdcashd
mv bdcash-cli /usr/bin/bdcash-cli
chmod 777 /usr/bin
rm -rf bin
rm BDCash-Protocol-BinariesV2-0-ubuntu18.zip

#RUNNING WALLET FOR THE FIRST TIME
bdcashd &
sleep 10s
pkill bdcashd

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
logtimestamps=1" > "/root/.bdcash/bdcash.conf"

#INSTALL NODEJS
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install pm2 -g

#INSTALL MONGODB
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update
sudo apt-get install -y mongodb-org
mkdir data
ulimit -n 640000

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
ufw deny 36263
ufw deny 27017
ufw allow 36264
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
