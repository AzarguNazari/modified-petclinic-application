job "mysql" {
  datacenters = ["dc1"]

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert = true
    canary = 0
  }

  group "mysql" {
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
      port "mysql-port" { static = 3306 }
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


