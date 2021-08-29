#!/bin/bash

docker volume create mysql-data

# Deploy database stack
docker stack deploy --resolve-image always -c docker-compose.yml database --with-registry-auth --prune

