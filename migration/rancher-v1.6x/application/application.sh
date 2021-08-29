#!/bin/bash
export RANCHER_URL='http://playground-hazar-1.fvndo.net:8080/v1/projects/1a5'
export RANCHER_ACCESS_KEY='930C7C93D3EF51484858'
export RANCHER_SECRET_KEY='QiUuJWyZLGrx2LTYaBDFVdedad4BXB1GLTGdFvYJ'
../rancher  -w --wait-state healthy up --prune --upgrade --stack application -d  --confirm-upgrade