#!/usr/bin/env bash

if [[ "$EUID" -ne 0 ]]; then
    cat <<- EOF >&2
error: please run as root
syntax) sudo kwok-testenv-setup.sh <docker user> <go version>
ex) sudo kwok-testenv-setup.sh myloginid 1.20.2
EOF
    exit 1
fi

pat='^[0-9]+[.][0-9]+[.][0-9]+$'
if [[ (-z $1) || ! ( $2 =~ $pat ) ]] ; then
    cat <<- EOF >&2
error: invalid parameters
syntax) sudo kwok-testenv-setup.sh <docker user> <go version>
ex) sudo kwok-testenv-setup.sh myloginid 1.20.2
EOF
    exit 2
fi

DOCKER_USER=$1
PREF_GO_VER=$2

sudo ./_go-install-ubuntu.sh ${PREF_GO_VER}
sudo ./_docker-install-ubuntu.sh ${DOCKER_USER}
sudo ./_minikube-install-ubuntu.sh
sudo ./_kwok-install-ubuntu.sh
