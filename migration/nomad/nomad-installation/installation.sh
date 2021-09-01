#!/bin/bash

#  ssh fadmin@playground-hazar-1.fvndo.net  screen -d -m < run_agent.sh

install_nomad() {
  echo "Install Nomad"

  for node in {1..3}; do
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'bash -s ' < ./install_nomad.sh
  done
}

cluster_configuration() {


#  sleep 5

  SERVER1=$(ssh fadmin@playground-hazar-1.fvndo.net 'echo $(ip -4 addr show eth0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1)')

  ssh fadmin@playground-hazar-1.fvndo.net 'bash -s ' < run_server.sh &
  ssh fadmin@playground-hazar-2.fvndo.net 'bash -s ' < run_agent.sh &
  ssh fadmin@playground-hazar-3.fvndo.net 'bash -s ' < run_agent.sh &

  ssh fadmin@playground-hazar-2.fvndo.net 'bash -s ' < join_worker_nodes.sh $SERVER1
  ssh fadmin@playground-hazar-3.fvndo.net 'bash -s ' < join_worker_nodes.sh $SERVER2

  ssh fadmin@playground-hazar-1.fvndo.net 'consul agent -dev &'
#    ssh fadmin@playground-hazar-1.fvndo.net 'bash -s ' < run_consul.sh &
#    ssh fadmin@playground-hazar-1.fvndo.net 'bash -s ' < run_fabio.sh &
}

remove_nomad() {
   for node in {1..3}; do
      ssh fadmin@playground-hazar-"${node}".fvndo.net 'sudo kill -9 `sudo lsof -t -i:4648`'
      ssh fadmin@playground-hazar-"${node}".fvndo.net 'sudo kill -9 `sudo lsof -t -i:8500`'
      ssh fadmin@playground-hazar-"${node}".fvndo.net 'nomad stop'
      ssh fadmin@playground-hazar-"${node}".fvndo.net 'docker rm $(docker ps -a -q) --force'
      ssh fadmin@playground-hazar-"${node}".fvndo.net 'sudo rm -rf /etc/nomad.d/'
      ssh fadmin@playground-hazar-"${node}".fvndo.net 'yes | sudo apt-get remove nomad'
      ssh fadmin@playground-hazar-"${node}".fvndo.net 'sudo rm -rf /usr/bin/nomad'
      echo "nomad $node is removed"
   done
}

node_leave_cluster() {
  for node in {1..3}; do
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'nomad server force-leave playground-hazar-1.global'
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'nomad server force-leave playground-hazar-2.global'
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'nomad server force-leave playground-hazar-3.global'
     echo "node $node is leaving the cluster"
  done
}

nomad_installation_verification() {
  for node in {1..3}; do
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'nomad version && consul version'
  done
}

deploy_app() {
   ssh fadmin@playground-hazar-1.fvndo.net 'git clone https://github.com/AzarguNazari/example-voting-app.git'
   ssh fadmin@playground-hazar-1.fvndo.net 'docker stack deploy --compose-file /home/fadmin/example-voting-app/docker-stack.yml vote'
}


node_leave_cluster
remove_nomad
#install_nomad
#nomad_installation_verification
#cluster_configuration
#deploy_app
