# Deploy Petclinic on Rancher v1.6x

## Prerequisites:
- Docker installed
- Docker Compose installed

## To install docker swarm cluster:
We used a 3-node cluster using Hetnzer [CX41](https://www.hetzner.com/cloud)
Run the Rancher v1.6x server on Server node: 
```shell
docker run -d -p 8080:8080 --privileged rancher/server
```

## How to run?
```shell
sh ./deploy.sh
```

**Note**: We used Portainer as management tool for docker swarm.
![Docker Swarm Portainer](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/docker-swarm-portainer.png?raw=true)
