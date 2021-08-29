#!/bin/bash

docker network create -d overlay database

docker stack deploy --resolve-image always -c docker-compose.yml database --with-registry-auth --prune

