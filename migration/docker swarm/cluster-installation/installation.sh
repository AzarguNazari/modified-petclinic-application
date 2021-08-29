#!/bin/bash

function install_docker_swarm {
  echo "--------------------"
  echo "Install Docker Swarm"
  echo "--------------------"

  for node in {1..3}; do
    open_swarm_port $node
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'base=https://github.com/docker/machine/releases/download/v0.16.0 && curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && sudo mv /tmp/docker-machine /usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine'
  done
}

function select_leader {

  echo "--------------------"
  echo "Selecting Leader and Worker Nodes started"
  echo "--------------------"


  LEADER_IP=$(ssh fadmin@playground-hazar-1.fvndo.net 'echo $(ip -4 addr show eth0 | grep -oP "(?<=inet\s)\d+(\.\d+){3}" | head -n 1)')
  echo "Leader node IP is $LEADER_IP"

  ssh fadmin@playground-hazar-1.fvndo.net 'bash -s ' < run.sh $LEADER_IP

  JOIN_TOKEN=$(ssh fadmin@playground-hazar-1.fvndo.net 'echo $(docker swarm join-token -q manager)')
  echo "Join token is $JOIN_TOKEN"

  for node in {2..3}; do
    ssh fadmin@playground-hazar-${node}.fvndo.net 'bash -s ' < join_worker_nodes.sh $JOIN_TOKEN $LEADER_IP
  done

}

open_swarm_port() {
  ssh fadmin@playground-hazar-"$1".fvndo.net 'sudo ufw allow 2377' # cluster management communication
  ssh fadmin@playground-hazar-"$1".fvndo.net 'sudo ufw allow 7946' # communication among nodes
  ssh fadmin@playground-hazar-"$1".fvndo.net 'sudo ufw allow 4789' # overlay network communication
}

node_leave_swarm() {
  for node in {1..3}; do
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'sudo docker swarm leave --force'
  done
}

remove_docker_machines() {
   for node in {1..3}; do
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'sudo rm -rf /usr/local/bin/docker-machine'
     echo "docker machine from node $node is removed"
   done
}

function verify_docker_swarm_installation {
  for node in {1..3}; do
    ssh fadmin@playground-hazar-"${node}".fvndo.net 'docker-machine version'
  done
}

remove_keygen_from_nodes() {
  for node in {1..3}; do
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'rm ~/.ssh/id_rsa.pub'
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'rm ~/.ssh/id_rsa'
     echo "keygen is removed from node $node"
   done
}

docker_registry_login() {
  for node in {1..3}; do
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'cd ~/.ssh && ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""'
     ssh fadmin@playground-hazar-"${node}".fvndo.net 'cat ~/.ssh/id_rsa.pub'
     echo "install ssh on node $node"
   done
}

add_labels() {
   ssh fadmin@playground-hazar-1.fvndo.net 'docker node update --label-add application=true playground-hazar-1'
   ssh fadmin@playground-hazar-1.fvndo.net 'docker node update --label-add monitoring=true playground-hazar-1'
   ssh fadmin@playground-hazar-2.fvndo.net 'docker node update --label-add application=true playground-hazar-2'
   ssh fadmin@playground-hazar-2.fvndo.net 'docker node update --label-add monitoring=true playground-hazar-2'
   ssh fadmin@playground-hazar-3.fvndo.net 'docker node update --label-add application=true playground-hazar-3'
   ssh fadmin@playground-hazar-3.fvndo.net 'docker node update --label-add monitoring=true playground-hazar-3'
}

create_context(){
  docker context create master --docker "host=ssh://fadmin@playground-hazar-1.fvndo.net"
}

#node_leave_swarm
#remove_docker_machines
#install_docker_swarm
#select_leader
#verify_docker_swarm_installation
add_labels

