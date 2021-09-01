#!/bin/bash

#SERVER1=$1
#SERVER2=$2
#
#echo "server 1 ip is $SERVER1"
#echo "server 2 ip is $SERVER2"

nomad sever join $1
#nomad sever join $SERVER2
echo "client node $2 is running"
