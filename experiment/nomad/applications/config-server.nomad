job "config-server" {
  datacenters = ["dc1"]

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "config-server" {
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
      port "config-server-port" { to = 8888 }
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
  }
}


