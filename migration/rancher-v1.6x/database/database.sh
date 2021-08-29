#!/bin/sh
export RANCHER_URL='http://playground-hazar-1.fvndo.net:8080/v1/projects/1a5'
export RANCHER_ACCESS_KEY='DD8012BE1F616CC72150'
export RANCHER_SECRET_KEY='JEoW3sg7hed8fBx59Aiir7np7jNY8KBuT1s675rB'

../rancher  -w --wait-state healthy up --prune --upgrade --stack database -d  --confirm-upgrade
