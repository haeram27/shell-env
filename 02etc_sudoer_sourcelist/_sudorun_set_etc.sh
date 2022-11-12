#!/bin/bash

if (( $EUID != 0 )); then
    echo "This script must be run as root"
    exit 3
fi


###################
# source list
###################

[[ ! -f /etc/apt/sources.list.origin ]] && cp /etc/apt/sources.list /etc/apt/sources.list.origin

if ! grep -q kakao /etc/apt/sources.list; then
    cp /etc/apt/sources.list /etc/apt/sources.list.$(date '+%Y%m%d%k%M%S').bak
    sed -isre 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
    sed -isre 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
fi



###################
# sudoers
###################
if [[ ! -f /etc/sudoers.d/90-additional-users ]]; then
    cp ./90-additional-users /etc/sudoers.d/
    chmod 440 /etc/sudoers.d/90-additional-users
fi
