#!/usr/bin/env bash

if [[ $(ss -tlnp | grep -Po 9913 | wc -l) -ge 1 ]]; then
  export http_proxy=${http_proxy:-"localhost:9913"}
  export https_proxy=${https_proxy:-"localhost:9913"}
fi

DOCKER_USER=${USER}

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
