#!/bin/bash

if (( $EUID != 0 )); then
    echo "This script must be run as root"
    exit 3
fi


###################
# source list
###################
if [[ $(lsb_release -i -s) = "Ubuntu" ]]; then
    [[ ! -f /etc/apt/sources.list.origin ]] && cp /etc/apt/sources.list /etc/apt/sources.list.origin

    if ! grep -q kakao /etc/apt/sources.list; then
    cp /etc/apt/sources.list /etc/apt/sources.list.$(date '+%Y%m%d%k%M%S').bak
    sed -i -s -r -e 's/\/kr.archive.ubuntu.com/\/mirror.kakao.com/g' /etc/apt/sources.list
    sed -i -s -r -e 's/\/archive.ubuntu.com/\/mirror.kakao.com/g' /etc/apt/sources.list
    sed -i -s -r -e 's/\/security.ubuntu.com/\/mirror.kakao.com/g' /etc/apt/sources.list
    fi

    if [[ $(ss -tlnp | grep -Po 9913 | wc -l) -ge 1 ]]; then
    cat <<- EOF > /etc/apt/apt.conf.d/proxy.conf 
    Acquire::http::Proxy "http://localhost:9913";
    Acquire::https::Proxy "http://localhost:9913";
    EOF
    fi
fi


###################
# sudoers
###################
if [[ ! -f /etc/sudoers.d/90-additional-users ]]; then
    echo $(logname)' ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-additional-users
    chmod 440 /etc/sudoers.d/90-additional-users
    cat /etc/sudoers.d/90-additional-users
fi
