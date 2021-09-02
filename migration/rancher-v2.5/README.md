# Deploy Petclinic on Docker Swarm

## Prerequisites:
- 3 machines with specification of 4 vCPU and 16 GB memory we used Hetnzer [CX41](https://www.hetzner.com/cloud) 
- Ubuntu 20.04
- Docker 18.09.9

# Installation
- On node 1, the Rancher v2.5 platform is instead using the command: ` docker run -d -p 80:80 -p 443:443 --privileged --restart=unless-stopped rancher/rancher:v2.5-head`
- On the initial page, Rancher v2.5 will ask for password setting:
![image](https://user-images.githubusercontent.com/17498897/131835928-f8fad6fd-b7cf-43ec-9a8d-f449766828d9.png)
- On the second page, it will verify the platform's host address:
![verify phase](https://github.com/AzarguNazari/modified-petclinic-application/blob/master/media/rancher-2.5-second-phase.png?raw=true)
- As the Rancher v2.5 platform gets ready, users can add server and client:
![add cluster](https://github.com/AzarguNazari/modified-petclinic-application/blob/master/media/rancher-2.5-creating-cluster.png?raw=true) 
- For RKE server which also includes the etc, the generated command looks like:
```shell
sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run  rancher/rancher-agent:v2.5-47e2c3e7324fb74c643ec877db0272ab500b5097-head --server https://playground-hazar-1.fvndo.net --token vgk6qmvcvw6j6bgxmjhts5xtv6klqwcq4gvrn66gnj5s2ww8zvbwvn --ca-checksum 60e2fd5c4328b375dcb04348cd510568963df91bc9dc507cb784589fa0b99710 --etcd --controlplane --worker```
- For RKE worker nodes, the generated command would be like this:
```shell
sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run  rancher/rancher-agent:v2.5-47e2c3e7324fb74c643ec877db0272ab500b5097-head --server https://playground-hazar-1.fvndo.net --token vgk6qmvcvw6j6bgxmjhts5xtv6klqwcq4gvrn66gnj5s2ww8zvbwvn --ca-checksum 60e2fd5c4328b375dcb04348cd510568963df91bc9dc507cb784589fa0b99710 --worker
```
- Paste the generated commands for server on node-2, and for worker node on node-3.
- The ready cluster would look lie:
![K3s-portainer](https://github.com/AzarguNazari/modified-petclinic-application/blob/master/media/ready-cluster.png?raw=true)

- To deploy the services, you can use the kubernetes deployments under `./deployment/` directory.
