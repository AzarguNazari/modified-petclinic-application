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

Additional steps:
- Generate a API key to access rancher cluster remotely: API > Keys > Add Account Api Key > create new account > copy the generated TOKENS
- Past the generated token and rancher URL to: 
```shell
export RANCHER_URL='http://playground-hazar-1.fvndo.net:8080/v1/projects/1a5'
export RANCHER_ACCESS_KEY='DD8012BE1F616CC72150'
export RANCHER_SECRET_KEY='JEoW3sg7hed8fBx59Aiir7np7jNY8KBuT1s675rB'
```

# Run the following command to deploy Petclinic application on Rancher remotely?
```shell
sh ./deploy.sh
```

- After the successful deployment, the Rancher cluster shows its ready state:
![Ready Rancher](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/ready-rancher.png?raw=true)
