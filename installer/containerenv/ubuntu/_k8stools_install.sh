#!/usr/bin/env bash

sudo rm -f /etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/$(curl -Ls https://dl.k8s.io/release/stable.txt | grep -Po '^v\d+.\d+')/deb/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg
echo deb '[signed-by=/etc/apt/trusted.gpg.d/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/'$(curl -Ls https://dl.k8s.io/release/stable.txt | grep -Po "^v\d+.\d+")'/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get remove -y kubelet kubeadm kubectl
sudo apt-get install -y kubelet kubeadm kubectl
