# Deploy Petclinic on Docker Swarm

## Prerequisites:
- Docker installed
- Docker Compose installed

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