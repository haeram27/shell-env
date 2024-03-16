#!/usr/bin/env bash

# ==== install web downloads tools
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version 2>/dev/null && rm -f ./minikube-linux-amd64 || { echo "failed to install minikube."; exit 1; }

# add alias
alias kk="kubectl"
alias ik="minikube kubectl -- "

## ==== download materials and create cluster in minikube
minikube start 
# minikube start -p kwok
# kubectl config use-context kwok

