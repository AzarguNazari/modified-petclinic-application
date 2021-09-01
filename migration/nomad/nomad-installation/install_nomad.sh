#!/bin/bash

echo "---------------------"
echo "Nomad installation"
echo "---------------------"

echo "---------- Port opening ------------"
fuser -k 4646/tcp
sudo ufw allow 4646
fuser -k 4647/tcp
sudo ufw allow 4647
fuser -k 4848/tcp
sudo ufw allow 4848
sudo ufw allow 4648
fuser -k 5656/tcp
sudo ufw allow 5656

sudo bash -c 'echo "49152 65535" > /proc/sys/net/ipv4/ip_local_port_range'

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
        && sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
        && sudo apt-get update \
        && sudo apt-get install nomad \
        && sudo apt install consul

