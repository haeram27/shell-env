#!/usr/bin/env bash
CFSSL_VERSION=1.6.5
CFSSL_VERSION_LATEST=$(curl -L --silent "https://api.github.com/repos/cloudflare/cfssl/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/^.//')
CFSSL_PATH=/usr/local/bin
ARCH=amd64

curl -L "https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssl_${CFSSL_VERSION}_linux_${ARCH}" -o cfssl
curl -L "https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssljson_${CFSSL_VERSION}_linux_${ARCH}" -o cfssljson
curl -L "https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssl-certinfo_${CFSSL_VERSION}_linux_${ARCH}" -o cfssl-certinfo

chmod +x cfssl cfssljson cfssl-certinfo
# sudo cp cfssl cfssljson cfssl-certinfo ${CFSSL_PATH}/
