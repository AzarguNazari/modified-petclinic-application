#!/bin/bash

function logs {
  sudo k3s kubectl logs $1
}

function getall {
  sudo k3s kubectl get all
}

function describe {
  sudo k3s kubectl describe $1
}

function delete {
  sudo k3s kubectl delete -f $1
}

function deleteAll {
  sudo k3s kubectl delete all --all
}