#!/usr/bin/env bash

if [[ $(ss -tlnp | grep -Po 9913 | wc -l) -ge 1 ]]; then
  export http_proxy=${http_proxy:-"localhost:9913"}
  export https_proxy=${https_proxy:-"localhost:9913"}
fi

CFSSL_VERSION=$(curl -L --silent "https://api.github.com/repos/cloudflare/cfssl/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^.//')
CFSSL_PATH=/usr/local/bin
ARCH=amd64

curl -L "https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssl_${CFSSL_VERSION}_linux_${ARCH}" -o cfssl
curl -L "https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssljson_${CFSSL_VERSION}_linux_${ARCH}" -o cfssljson
curl -L "https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssl-certinfo_${CFSSL_VERSION}_linux_${ARCH}" -o cfssl-certinfo

chmod +x cfssl cfssljson cfssl-certinfo
# sudo cp cfssl cfssljson cfssl-certinfo ${CFSSL_PATH}/
