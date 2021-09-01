#!/bin/bash

install_k3s_master_node() {
  echo "Install K3s master node"
  ssh fadmin@playground-hazar-1.fvndo.net 'curl -sfL https://get.k3s.io | sh -'
}

install_k3s_worker_node() {
  echo "Install K3s worker node"
  TOKEN=$(ssh fadmin@playground-hazar-1.fvndo.net 'echo $(sudo cat /var/lib/rancher/k3s/server/node-token)')
  for node in {2..3}; do
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'export K3S_URL="https://10.12.66.37:6443"'
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'export K3S_TOKEN="K10e9fd828806f453fa2293e4fa7e5db51696b29565819b2a5a0320c3b620572b01::node:519d266f594a54673f1f52bef47443e1"'
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'curl -sfL https://get.k3s.io | sh -'
  done
}

remove_k3s() {
  # complete removal of the k3s
  ssh fadmin@playground-hazar-"${node}".fvndo.net 'command for uninstallation of k3s'  # needs to be overriden
}

remove_k3s() {
   for node in {1..3}; do
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'command for removing k3s bin'
     echo "k3s from node $node is removed"
   done
}

#https://gist.github.com/ruanbekker/d999161cde3e440194b3f7cd60d57fc2

k3s_installation_verification() {
  for node in {1..3}; do
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'kubectl get nodes'
  done
}

deploy_app() {
   ssh fadmin@playground-hazar-1.fvndo.net 'get example from k3s-demo.yml'
   ssh fadmin@playground-hazar-1.fvndo.net 'kubectl apply -f k3s-demo.yml'
}

install_k3s_master_node
install_k3s_worker_node