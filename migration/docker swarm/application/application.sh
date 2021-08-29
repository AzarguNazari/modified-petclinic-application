#!/bin/bash

docker network create -d overlay application

docker stack deploy --resolve-image always -c docker-compose.yml applications --with-registry-auth --prune

