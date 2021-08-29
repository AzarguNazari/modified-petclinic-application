job "prometheus-server" {
  datacenters = ["dc1"]

  update {
    stagger = "30s"
    max_parallel = 1
  }

  group "prometheus-server" {
    count = 1

    ephemeral_disk {
      size = 600
      migrate = true
    }

    network {
      port "prometheus_ui" {
        to = 9090
      }
    }

    task "prometheus-server" {
      driver = "docker"

//      artifact {
//        # Double slash required to download just the specified subdirectory, see:
//        # https://github.com/hashicorp/go-getter#subdirectories
//        source = "git::https://github.com/fhemberger/nomad-demo.git//nomad_jobs/artifacts/prometheus"
//      }

      config {
        image = "nazariazargul/prometheus-server"

        cap_drop = ["ALL"]

//        volumes = [
//          "local/prometheus.yml:/etc/prometheus/prometheus.yml:ro",
//        ]

        ports = ["prometheus_ui"]

      }

      resources {
        cpu = 100
        memory = 100
      }

      service {
        name = "prometheus-server"

        tags = ["http"]

        port = "prometheus_ui"

        check {
          type = "http"
          path = "/-/healthy"
          interval = "10s"
          timeout = "2s"
        }
      }

    }
  }
}