job "admin-server" {

  datacenters = ["dc1"]

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "admin-server" {

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

      env {
        CONFIG_SERVER = "config-server"
      }

      resources {
        memory = 500
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
  }
}
