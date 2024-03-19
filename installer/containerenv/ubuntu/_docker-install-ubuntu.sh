#!/usr/bin/env bash
if [[ -z $1 ]]; then
    echo 'error: please input docker user name to add docker group as 1st argument.'
    echo 'ex) sudo docker-install-ubuntu.sh ${USER}'
    exit 1
fi
DOCKER_USER=$1

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/trusted.gpg.d/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker ${DOCKER_USER}
newgrp docker
getent group docker
