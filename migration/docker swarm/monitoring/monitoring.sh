#!/bin/bash

# Deploy portainer stack
docker stack deploy --resolve-image always -c docker-compose.yml monitoring --with-registry-auth --prune

