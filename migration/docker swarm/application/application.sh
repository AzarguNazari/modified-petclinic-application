#!/bin/bash

# Deploy application stack
docker stack deploy --resolve-image always -c docker-compose.yml applications --with-registry-auth --prune

