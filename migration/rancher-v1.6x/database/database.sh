#!/bin/sh
export RANCHER_URL='http://playground-hazar-1.fvndo.net:8080/v1/projects/1a5'
export RANCHER_ACCESS_KEY='68F30E71831D3D24CF55'
export RANCHER_SECRET_KEY='YgzC1irKbZBEFy9hdGMQLk3bvR9Neqy6tFYVryxW'

../rancher  -w --wait-state healthy up --prune --upgrade --stack database -d  --confirm-upgrade
