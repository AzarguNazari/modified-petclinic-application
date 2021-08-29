#!/bin/bash

docker swarm join --token "$1" "$2":2377

