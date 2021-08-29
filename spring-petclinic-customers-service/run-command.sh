#!/bin/bash

mvn -DSPRING_BOOT_ADMIN=localhost -DCONFIG_SERVER=localhost spring-boot:run -DskipTests
