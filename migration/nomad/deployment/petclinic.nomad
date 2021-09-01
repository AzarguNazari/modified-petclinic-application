job "petclinic" {

  datacenters = ["dc1"]

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert = true
    canary = 0
  }

  group "applications" {

    count = 1

    ephemeral_disk{
      migrate = true
      size=300
      sticky  = true
    }

    restart{
      attempts=10
      interval="5m"
      delay="25s"
      mode="delay"
    }

    network {
      port "mysql" { static = 3306 }
      port "phpmyadmin" {static = 80}
      port "http" { to = 3000 }
      port "admin-server-port" { static = 9090 }
      port "api-gateway-port" { to = 8080 }
      port "config-server-port" { to = 8888 }
      port "customers-service-port" { to = 8081 }
      port "prometheus_ui" {
        to = 9090
      }
      port "vets-service" { to = 8083 }
      port "visits-service" { to = 8082 }
    }

    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:5.7.32"
        force_pull = true
        ports = ["mysql"]
      }

      env {
        MYSQL_ROOT_PASSWORD = "petclinic"
        MYSQL_DATABASE = "petclinic"
      }

      service {
        name = "mysql"
        tags = ["mysql"]
        port = "mysql"
      }
    }

    task "phpmyadmin" {
      driver = "docker"

      config {
        image = "phpmyadmin/phpmyadmin"
        cap_drop = ["ALL"]
        ports = ["phpmyadmin"]
      }

      env{
        PMA_HOST = localhost
        PMA_PORT = 3306
        PMA_ARBITRARY = 1
      }

      service {
        name = "phpmyadmin"
        tags = ["urlprefix-/phpmyadmin"]
        port = "phpmyadmin"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }

    task "grafana-server" {
      driver = "docker"

      config {
        image = "nazariazargul/grafana-server"

        cap_drop = [
          "ALL",
        ]

        //        volumes = [
        //          "local:/etc/grafana:ro",
        //        ]

        ports = ["http"]
      }


      resources {
        cpu    = 100
        memory = 50
      }

      service {
        name = "grafana"
        tags = ["http"]
        port = "http"

        check {
          type     = "http"
          path     = "/api/health"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }

    task "admin-server" {
      driver = "docker"

      config {
        image = "nazariazargul/petclinic-admin-server:4.0"
        cap_drop = ["ALL"]
        ports = ["admin-server-port"]
        hostname = "user.service.consul"
        network_mode = "petclinic"
      }

      env {
        CONFIG_SERVER = "config-server"
      }

      resources {
        memory = 800
      }

      service {
        name = "admin-server"
        tags = ["http"]
        port = "admin-server-port"

        check {
          type     = "http"
          path     = "/spring-boot-admin/actuator/health"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }

    task "api-gateway" {
      driver = "docker"

      config {
        image = "nazariazargul/petclinic-api-gateway:4.0"
        ports = ["api-gateway-port"]
        hostname = "user.service.consul"
        network_mode = "petclinic"
      }

      env{
        SPRING_BOOT_ADMIN = "admin-server"
        CONFIG_SERVER = "config-server"
        VETS_SERVICE = "vets-service"
        VISITS_SERVICE = "visits-service"
        CUSTOMER_SERVICE = "customers-service"
        SPRING_ZIPKIN_BASEURL = "http://tracing-server:9411/"
      }

      resources {
        memory = 700
      }

      service {
        name = "api-gateway"
        tags = ["http"]
        port = "api-gateway-port"

        check {
          type     = "http"
          path     = "/actuator/health"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }

    task "config-server" {
      driver = "docker"

      config {
        image = "nazariazargul/petclinic-config-server:4.0"

        cap_drop = ["ALL"]

        //        volumes = [
        //          "local:/etc/grafana:ro",
        //        ]

        ports = ["config-server-port"]
        hostname = "user.service.consul"
        network_mode = "petclinic"
      }


      resources {
        memory = 500
      }

      service {
        name = "config-server"
        tags = ["http"]
        port = "config-server-port"

        check {
          type     = "http"
          path     = "/actuator/health"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }

    task "customers-service" {
      driver = "docker"

      config {
        image = "nazariazargul/petclinic-customers-service:4.0"

        cap_drop = ["ALL"]

        //        volumes = [
        //          "local:/etc/grafana:ro",
        //        ]

        ports = ["customers-service-port"]
      }

      env{
        SPRING_BOOT_ADMIN = "admin-server"
        CONFIG_SERVER = "config-server"
        MYSQL_HOST = "mysql"
        SPRING_ZIPKIN_BASEURL = "http://tracing-server:9411/"
      }

      resources {
        memory = 500
      }

      service {
        name = "customers-service"
        tags = ["http"]
        port = "customers-service-port"

        check {
          type     = "http"
          path     = "/actuator/health"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }

    task "prometheus-server" {
      driver = "docker"

      config {
        image = "nazariazargul/prometheus-server"
        cap_drop = ["ALL"]
        ports = ["prometheus_ui"]
        hostname = "premetheus.service.consul"
        network_mode = "petclinic"
      }

      resources {
        cpu = 100
        memory = 100
      }

      service {
        name = "prometheus-server"

        tags = ["prometheus_ui"]

        port = "prometheus_ui"

        check {
          type = "http"
          path = "/-/healthy"
          interval = "10s"
          timeout = "2s"
        }
      }

    }

    task "vets-service" {
      driver = "docker"

      config {
        image = "nazariazargul/petclinic-vets-service:4.0"

        cap_drop = ["ALL"]
        ports = ["vets-service"]
        hostname = "vets.service.consul"
        network_mode = "petclinic"
      }

      env{
        SPRING_BOOT_ADMIN = "admin-server"
        CONFIG_SERVER = "config-server"
        MYSQL_HOST = "mysql"
        SPRING_ZIPKIN_BASEURL = "http://tracing-server:9411/"
      }

      resources {
        memory = 500
      }

      service {
        name = "vets-service"
        tags = ["vets-service"]
        port = "vets-service"

        check {
          type     = "http"
          path     = "/actuator/health"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }

    task "visits-service" {
      driver = "docker"

      config {
        image = "nazariazargul/petclinic-visits-service:4.0"
        cap_drop = ["ALL"]
        ports = ["visits-service"]
        hostname = "visits.service.consul"
        network_mode = "petclinic"
      }

      env{
        SPRING_BOOT_ADMIN = "admin-server"
        CONFIG_SERVER = "config-server"
        MYSQL_HOST = "mysql"
        SPRING_ZIPKIN_BASEURL = "http://tracing-server:9411/"
      }

      resources {
        memory = 500
      }

      service {
        name = "visits-service"
        tags = ["visits-service"]
        port = "visits-service"

        check {
          type     = "http"
          path     = "/actuator/health"
          interval = "10s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }
      }
    }
  }
}


