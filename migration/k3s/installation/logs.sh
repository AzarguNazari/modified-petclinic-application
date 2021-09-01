#!/bin/bash

sudo kubectl logs -l app=client

kubectl port-forward mongo-75f59d57f4-4nd6q 28015:27017

