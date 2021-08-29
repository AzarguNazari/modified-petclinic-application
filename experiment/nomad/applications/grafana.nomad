job "grafana-server" {
  datacenters = ["dc1"]

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "grafana-server" {
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
      port "http" { to = 3000 }
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
  }
}