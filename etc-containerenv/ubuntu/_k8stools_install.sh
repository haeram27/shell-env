#!/usr/bin/env bash

if [[ "$EUID" -ne 0 ]]; then
    echo 'error: please run as root'
    echo 'ex) sudo docker-install-ubuntu.sh ${USER}'
    exit 1
fi

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/$(curl -Ls https://dl.k8s.io/release/stable.txt)/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$(curl -Ls https://dl.k8s.io/release/stable.txt)/deb/ /" |  $ sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get remove -y kubelet kubeadm kubectl
sudo apt-get install -y kubelet kubeadm kubectl
