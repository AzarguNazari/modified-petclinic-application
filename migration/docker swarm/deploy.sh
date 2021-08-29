#!/bin/bash

# Create a global overlay network
docker network create -d overlay --attachable global

(cd ./database && sh database.sh)
(cd ./application && sh application.sh)
(cd ./monitoring && sh monitoring.sh)
