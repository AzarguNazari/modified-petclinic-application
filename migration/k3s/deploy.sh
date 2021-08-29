#!/bin/bash

#sudo kubectl create namespace spring-petclinic

# deploy config-server
sudo kubectl apply -f config-server-deployment.yaml

# deploy mysql
sudo kubectl apply -f mysql-deployment.yaml


# deploy phpmyadmin
sudo kubectl apply -f phpmyadmin-deployment.yaml

# deploy tracing server
sudo kubectl apply -f tracing-server-deployment.yaml


# deploy premetheus server
sudo kubectl apply -f premetheus-server-deployment.yaml


# deploy grafana server
sudo kubectl apply -f grafana-server-deployment.yaml

# deploy api gateway
sudo kubectl apply -f api-gateway-deployment.yaml

# deploy customer service
sudo kubectl apply -f customers-service-deployment.yaml

# deploy visits service
sudo kubectl apply -f visits-service-deployment.yaml

# deploy vets service
sudo kubectl apply -f vets-service-deployment.yaml

# deploy admin server
sudo kubectl apply -f admin-server-deployment.yaml

