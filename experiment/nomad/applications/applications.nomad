job "applications" {

  datacenters = ["dc1"]

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "applications" {

    count = 1

    ephemeral_disk {
      size    = 300
      migrate = true
    }

    restart {
      attempts = 3
      interval = "2m"
      delay    = "15s"
      mode     = "fail"
    }
    network {
      port "admin-server-port" { static = 9090 }
      port "admin-server-port" { static = 9090 }
    }
    task "admin-server" {
      driver = "docker"
      config {
        image = "nazariazargul/petclinic-admin-server:4.0"
        cap_drop = ["ALL"]
        //        volumes = [
        //          "local:/etc/grafana:ro",
        //        ]
        ports = ["admin-server-port"]
        hostname = "user.service.consul"
        network_mode = "petclinic"
      }
      env {CONFIG_SERVER = "config-server"}
      resources { memory = 500 }
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


    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:5.7.32"
        force_pull=true
        ports = ["mysql-port"]
        network_mode = "petclinic"
      }

      env {
        MYSQL_ROOT_PASSWORD = "petclinic"
        MYSQL_DATABASE = "petclinic"
      }

      logs{
        max_files=10
        max_file_size=15
      }
      resources{
        cpu=500
        memory=512
      }

      service {
        name = "mysql"
        tags = ["http"]
        port = "mysql-port"
      }
    }
  }
}
