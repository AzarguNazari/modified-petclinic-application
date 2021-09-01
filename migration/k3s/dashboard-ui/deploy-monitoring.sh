#!/bin/bash

GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
sudo k3s kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml

sudo k3s kubectl create -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml

sudo kubectl port-forward kubernetes-dashboard-67484c44f6-qzcqb 9000:443 -n kubernetes-dashboard

# obtain bear token
sudo k3s kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token'

sudo k3s kubectl proxy