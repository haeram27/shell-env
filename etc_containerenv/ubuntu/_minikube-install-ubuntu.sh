#!/usr/bin/env bash

if [[ "$EUID" -ne 0 ]]; then
    echo 'error: Please run as root'
    exit 1
fi

# ==== install web downloads tools
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# install kubectl
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# check supported kubernetes-<ubuntu-code>  https://packages.cloud.google.com/apt/dists
sudo wget -O /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
sudo sh -c "echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list"
sudo apt-get update
sudo apt-get install -y kubectl

# install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# add alias
$ alias kk="kubectl"
$ alias ik="minikube kubectl -- "

## ==== download materials and create cluster in minikube
minikube start 
# minikube start -p kwok
# kubectl config use-context kwok
