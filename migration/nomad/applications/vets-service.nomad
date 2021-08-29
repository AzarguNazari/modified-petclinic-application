job "vets-service" {

  datacenters = ["dc1"]

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "vets-service" {
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
      port "http" { to = 8083 }
    }

    task "vets-service" {
      driver = "docker"

      config {
        image = "nazariazargul/petclinic-vets-service:4.0"

        cap_drop = ["ALL"]

        //        volumes = [
        //          "local:/etc/grafana:ro",
        //        ]

        ports = ["http"]
      }

      env{
        SPRING_BOOT_ADMIN = "admin-server"
        CONFIG_SERVER = "config-server"
        MYSQL_HOST = mysql
        SPRING_ZIPKIN_BASEURL = "http://tracing-server:9411/"
      }

      resources {
        memory = 500
      }

      service {
        name = "vets-service"
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
  }
}


