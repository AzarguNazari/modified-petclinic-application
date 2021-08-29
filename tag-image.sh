#!/bin/bash

#docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

#for service in admin-server api-gateway config-server customers-service vets-service visits-service
#do
#  (cd "spring-petclinic-$service" && mvn spring-boot:build-image -DskipTests)
#done

export CURRENT_VERSION=experiment
export VERSION=4.0

#
docker tag spring-petclinic-admin-server:$CURRENT_VERSION      nazariazargul/petclinic-admin-server:$VERSION
docker tag spring-petclinic-api-gateway:$CURRENT_VERSION       nazariazargul/petclinic-api-gateway:$VERSION
docker tag spring-petclinic-config-server:$CURRENT_VERSION     nazariazargul/petclinic-config-server:$VERSION
docker tag spring-petclinic-customers-service:$CURRENT_VERSION nazariazargul/petclinic-customers-service:$VERSION
docker tag spring-petclinic-vets-service:$CURRENT_VERSION      nazariazargul/petclinic-vets-service:$VERSION
docker tag spring-petclinic-visits-service:$CURRENT_VERSION    nazariazargul/petclinic-visits-service:$VERSION

docker push nazariazargul/petclinic-admin-server:$VERSION
docker push nazariazargul/petclinic-api-gateway:$VERSION
docker push nazariazargul/petclinic-config-server:$VERSION
docker push nazariazargul/petclinic-customers-service:$VERSION
docker push nazariazargul/petclinic-vets-service:$VERSION
docker push nazariazargul/petclinic-visits-service:$VERSION
