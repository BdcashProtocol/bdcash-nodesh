#!/bin/bash

touch .BOOTSTRAPPING
rm nodesh_bootstrap.gz
wget https://sfo2.digitaloceanspaces.com/bdcash/nodesh_bootstrap.gz
rm -rf nodesh
tar -xvzf nodesh_bootstrap.gz --strip-components 1
sleep 20s
mongorestore --db nodesh --drop nodesh
rm .BOOTSTRAPPING
rm -rf nodesh
rm nodesh_bootstrap.gz