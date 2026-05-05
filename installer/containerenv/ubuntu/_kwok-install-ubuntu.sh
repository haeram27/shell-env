#!/usr/bin/env bash

if [[ $(ss -tlnp | grep -Po 9913 | wc -l) -ge 1 ]]; then
  export http_proxy=${http_proxy:-"localhost:9913"}
  export https_proxy=${https_proxy:-"localhost:9913"}
fi

if [[ "$EUID" -ne 0 ]]; then
    echo 'error: please run as root'
    exit 1
fi

if ! type go &>/dev/null; then
    echo 'error: can NOT find go command'
fi

## ==== install kwok
# ==== set variables
# KWOK repository
KWOK_REPO=kubernetes-sigs/kwok
# Get latest
KWOK_LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${KWOK_REPO}/releases/latest" | jq -r '.tag_name')


# ==== Install kwokctl
wget -O kwokctl -c "https://github.com/${KWOK_REPO}/releases/download/${KWOK_LATEST_RELEASE}/kwokctl-$(go env GOOS)-$(go env GOARCH)"
chmod +x kwokctl
sudo mv kwokctl /usr/local/bin/kwokctl


# ==== install kwok
wget -O kwok -c "https://github.com/${KWOK_REPO}/releases/download/${KWOK_LATEST_RELEASE}/kwok-$(go env GOOS)-$(go env GOARCH)"
chmod +x kwok
sudo mv kwok /usr/local/bin/kwok
