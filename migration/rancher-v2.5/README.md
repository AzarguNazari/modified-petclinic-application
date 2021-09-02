# Deploy Petclinic on Docker Swarm

## Prerequisites:
- 3 machines with specification of 4 vCPU and 16 GB memory we used Hetnzer [CX41](https://www.hetzner.com/cloud) 
- Ubuntu 20.04
- Docker 18.09.9

# Installation
- On node 1, the Rancher v2.5 platform is instead using the command: ` docker run -d -p 80:80 -p 443:443 --privileged --restart=unless-stopped rancher/rancher:v2.5-head`
- The Rancher v2.5 platform will be ready:


- For RKE server which also provides etc, the command:
```shell
sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run  rancher/rancher-agent:v2.5-47e2c3e7324fb74c643ec877db0272ab500b5097-head --server https://playground-hazar-1.fvndo.net --token vgk6qmvcvw6j6bgxmjhts5xtv6klqwcq4gvrn66gnj5s2ww8zvbwvn --ca-checksum 60e2fd5c4328b375dcb04348cd510568963df91bc9dc507cb784589fa0b99710 --etcd --controlplane --worker```

- For RKE client node, the copied command loooks like this:
```shell
sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run  rancher/rancher-agent:v2.5-47e2c3e7324fb74c643ec877db0272ab500b5097-head --server https://playground-hazar-1.fvndo.net --token vgk6qmvcvw6j6bgxmjhts5xtv6klqwcq4gvrn66gnj5s2ww8zvbwvn --ca-checksum 60e2fd5c4328b375dcb04348cd510568963df91bc9dc507cb784589fa0b99710 --worker
```

```shell
NAME                 STATUS   ROLES                  AGE     VERSION
playground-hazar-1   Ready    control-plane,master   5m30s   v1.21.3+k3s1
playground-hazar-2   Ready    <none>                 89s     v1.21.3+k3s1
playground-hazar-3   Ready    <none>                 87s     v1.21.3+k3s1
```
![K3s-portainer](https://github.com/AzarguNazari/modifed-petclinic-application/blob/master/media/k3s-portainer.png)

- To deploy the services, use the `kubectl` command as follow:
```shell
sudo kubectl apply -f ./deployment/mysql-deployment.yaml
sudo kubectl apply -f ./deployment/admin-server-deployment.yaml
sudo kubectl apply -f ./deployment/phpmyadmin-deployment.yaml
sudo kubectl apply -f ./deployment/premetheus-server-deployment.yaml
sudo kubectl apply -f ./deployment/grafana-server-deployment.yaml
sudo kubectl apply -f ./deployment/tracing-server-deployment.yaml
sudo kubectl apply -f ./deployment/config-server-deployment.yaml
sudo kubectl apply -f ./deployment/api-gateway.yaml
sudo kubectl apply -f ./deployment/customers-service-deployment.yaml
sudo kubectl apply -f ./deployment/visits-service-deployment.yaml
sudo kubectl apply -f ./deployment/vets-service-deployment.yaml
```