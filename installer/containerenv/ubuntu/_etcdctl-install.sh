#!/usr/bin/env bash

if [[ $(ss -tlnp | grep -Po 9913 | wc -l) -ge 1 ]]; then
  export http_proxy=${http_proxy:-"localhost:9913"}
  export https_proxy=${https_proxy:-"localhost:9913"}
fi

ETCD_VER=v3.4.26

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

if [[ "${EUID}" -ne 0 ]]; then echo "error: please run as root"; exit 1; fi

rm -f /usr/local/bin/etcdctl &>/dev/null
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
mv /tmp/etcd-download-test/etcdctl /usr/local/bin/etcdctl
etcdctl version

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test
