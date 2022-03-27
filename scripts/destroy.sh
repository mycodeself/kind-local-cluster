#!/bin/bash
set -o errexit

kind delete cluster --name local-cluster

# delete kind-registry
echo "Deleting kind registry ..."
docker stop kind-registry > /dev/null 
docker rm kind-registry > /dev/null