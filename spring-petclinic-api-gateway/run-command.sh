#!/bin/bash

mvn -DSPRING_BOOT_ADMIN=localhost -DVETS_SERVICE=localhost -DVISIT_SERVICE=localhost -DCUSTOMER_SERVICE=localhost -DCONFIG_SERVER=localhost spring-boot:run -DskipTests
