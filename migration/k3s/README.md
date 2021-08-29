# Deploy Petclinic on Docker Swarm

## Prerequisites:
- Ubuntu 20.04

# Installation
- Run this command on server node to install k3s server `curl -sfL https://get.k3s.io | sh -`
- To make server node access `kubetctl` command, run the command `sudo chmod 777 /etc/rancher/k3s/k3s.yaml` on server node.
- To install Portainer UI for Kubernetes management, use [this](https://documentation.portainer.io/v2.0/deploy/ceinstallk8s/) guide to install 
- Generate server token on server node `$(sudo cat /var/lib/rancher/k3s/server/node-token)`. This token will be used by agents to access the server node.
- On agents, export these variables: `export K3S_URL="https://${SERVER_IP}:6443"`, `export K3S_TOKEN="${GENERATED_SERVER_TOKEN}"`
- On each agent, run the following command to join the cluster: `curl -sfL https://get.k3s.io | sh -`
- To know whether the agents are connected, use the `sudo kubectl get nodes` on server node. The output will look like this:
```shell
NAME                 STATUS   ROLES                  AGE     VERSION
playground-hazar-1   Ready    control-plane,master   5m30s   v1.21.3+k3s1
playground-hazar-2   Ready    <none>                 89s     v1.21.3+k3s1
playground-hazar-3   Ready    <none>                 87s     v1.21.3+k3s1
```
![K3s-portainer](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/k3s-portainer.png)

## To install docker swarm cluster:
We used a 3-node cluster using Hetnzer [CX41](https://www.hetzner.com/cloud)
```shell
sh ./cluster-installation/installation.sh
```

## How to run?
```shell
sh ./deploy.sh
```

**Note**: We used Portainer as management tool for docker swarm.
![Docker Swarm Portainer](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/docker-swarm-portainer.png?raw=true)
