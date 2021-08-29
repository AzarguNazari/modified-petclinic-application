#!/bin/bash

docker network create -d overlay --attachable globalnetwork

(cd ./database && sh database.sh)
(cd ./application && sh application.sh)
(cd ./monitoring && sh monitoring.sh)



#scp -r /home/hazarg/master-thesis/master-thesis-work/petclinic-microservices/spring-petclinic-microservices/experiment/docker* fadmin@playground-hazar-1.fvndo.net:/home/fadmin/test
