#!/usr/bin/env bash

CONTAINERD_VERSION=${CONTAINERD_VERSION:-$(curl -Ls "https://github.com/containerd/containerd/releases/latest" 2>&1 | grep -Po '(?<=''<title\>Release containerd '').+?(?='' · containerd/containerd · GitHub</title>'')')}


# containerd binary file
wget https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
sudo tar Czxvf /usr/local containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz

# containerd system service file
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /usr/lib/systemd/system

# load containerd on systemd
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
sudo systemctl is-active containerd
[[ $? -eq 0 ]] && rm -f ./containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz
