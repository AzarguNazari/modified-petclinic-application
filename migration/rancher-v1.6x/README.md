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

- The Rancher server will be available under port 8080. To add host, you can go to the INFRASTRUCTURE > HOSTS and click the `Add Host` button
![Add host](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/add-post.png?raw=true)
- After clicking the `Add Host`, new page comes to verify the server host address which looks as following image:
![verify server host](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/add-post-url.png?raw=true)
- Then copy the generated command and past it to the Rancher clients.
![generated command](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/copy-command.png?raw=true)
- Now the cluster is ready:
![Ready Cluster](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/added-hosts.png?raw=true)

# Run the following command to deploy Petclinic application on Rancher remotely?
```shell
sh ./deploy.sh
```
