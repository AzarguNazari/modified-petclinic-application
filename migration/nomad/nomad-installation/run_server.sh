#!/bin/bash

NODE_IP=$(echo $(ip -4 addr show eth0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1))
echo '
    data_dir = "/tmp/nomad"

    bind_addr = "0.0.0.0"

    advertise {
      rpc = "'$NODE_IP':4647"
      serf = "'$NODE_IP':4648"
    }

    server {
        enabled = true

        bootstrap_expect = 1
    }

#    client {
#        enabled = true
#
#        servers = ["127.0.0.1:4647"]
#        options {
#           "driver.allowlist" = "docker,exec,raw_exec"
#        }
#    }
    consul {
      address = "127.0.0.1:8500"
    }
    plugin "raw_exec" {
      config {
        enabled = true
      }
    }
' > node.hcl
nomad agent -config node.hcl
