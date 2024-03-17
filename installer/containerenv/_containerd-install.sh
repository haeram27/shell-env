#!/usr/bin/env bash
if [[ "$EUID" -ne 0 ]]; then
    echo 'error: please run as root'
    echo 'ex) sudo docker-install-ubuntu.sh ${USER}'
    exit 1
fi

# containerd binary file
wget https://github.com/containerd/containerd/releases/download/v1.6.2/containerd-1.6.2-linux-amd64.tar.gz
sudo tar Czxvf /usr/local containerd-1.6.2-linux-amd64.tar.gz

# containerd system service file
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /usr/lib/systemd/system

# load containerd on systemd
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
sudo systemctl is-active containerd
