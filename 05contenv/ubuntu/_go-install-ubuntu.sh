#!/usr/bin/env bash

if [[ "$EUID" -ne 0 ]]; then
    echo 'error: please run as root'
    echo 'ex) sudo go-install-ubuntu.sh 1.20.2'
    exit 1
fi

if [[ -z $1 ]]; then
    echo 'error: PREFERED_VER is required. Please input version as 1st argument'
    echo 'ex) sudo go-install-ubuntu.sh 1.20.2'
    exit 1
fi

PREFERED_VER=$1
ARCHIVE_NAME=go${PREFERED_VER}.linux-amd64.tar.gz

## ==== install go
curl -LOk https://go.dev/dl/${ARCHIVE_NAME}
if [[ $? != 0 || ! -f ./${ARCHIVE_NAME} ]]; then
    echo 'ERROR: cannot download archive of prefered version.'
    exit 2
fi

sudo rm -rf /opt/go; sudo mkdir /opt/go; sudo tar -C /opt -xzf ${ARCHIVE_NAME};

[[ -d /opt/go/bin ]] && rm -f ${ARCHIVE_NAME}

sudo bash -c 'cat << EOF > /etc/profile.d/go-path.sh
if [[ -d /opt/go/bin ]]; then
    export PATH=$PATH:/opt/go/bin
fi

if [[ -d /usr/local/go/bin ]]; then
    export PATH=$PATH:/usr/local/go/bin
fi

if [[ -d ${HOME}/go/bin ]]; then
    export PATH=$PATH:$HOME/go/bin
fi

if [[ -d ${HOME}/go/gopath-head/bin ]]; then
    export PATH=$PATH:${HOME}/go/gopath-head/bin
fi
EOF'

source /etc/profile.d/go-path.sh
go version
[[ $? = 0 && -f ./${ARCHIVE_NAME} ]] && rm -f ./${ARCHIVE_NAME}
