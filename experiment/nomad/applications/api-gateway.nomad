job "api-gateway" {

  datacenters = ["dc1"]

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "api-gateway" {
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
      port "api-gateway-port" { to = 8080 }
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
  }
}

