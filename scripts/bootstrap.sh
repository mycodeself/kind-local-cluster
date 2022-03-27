#!/bin/bash
set -o errexit

# create registry container unless it already exists
echo "Starting kind registry on port 5000 ..."
reg_name='kind-registry'
reg_port='5000'
running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"
if [ "${running}" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# create a cluster with the local registry enabled in containerd
kind create cluster --config=bootstrap/cluster.yml

echo "Configuring kind registry on cluster ..."
# connect the registry to the cluster network
# (the network may already be connected)
docker network connect "kind" "${reg_name}" || true

kubectl apply -f bootstrap/registry_configmap.yml

echo "Installing ingress NGINX ..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo ""
echo "Your cluster is ready! 😊"