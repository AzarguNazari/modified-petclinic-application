job "phpmyadmin" {
  datacenters = ["dc1"]

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "phpmyadmin" {
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
      port "phpmyadmin-port" {
        static = 9094
        to = 80
      }
    }

    task "phpmyadmin" {
      driver = "docker"

      config {
        image = "phpmyadmin/phpmyadmin"

        cap_drop = ["ALL"]

        //        volumes = [
        //          "local:/etc/grafana:ro",
        //        ]

        ports = ["phpmyadmin-port"]
      }

      env{
        PMA_HOST = localhost
        PMA_PORT = 3306
        PMA_ARBITRARY = 1
      }

      service {
        name = "phpmyadmin"
        tags = ["http"]
        port = "phpmyadmin-port"

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
  }
}


