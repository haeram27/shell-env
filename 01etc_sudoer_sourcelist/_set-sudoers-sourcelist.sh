#!/bin/bash

if (( $EUID != 0 )); then
    echo "This script must be run as root"
    exit 3
fi


#####################
## proxy
#####################
if [[ -f ~/.ssh/pfwd/pfwd.cust ]]; then
    . ~/.ssh/pfwd/pfwd.cust
fi

###################
# source list
###################
if [[ $(lsb_release -i -s) = "Ubuntu" ]]; then
    if [[ $(ss -tlnp | grep -Po 9913 | wc -l) -ge 1 ]]; then
    cat <<- EOF > /etc/apt/apt.conf.d/proxy.conf 
Acquire::http::Proxy "http://localhost:9913";
Acquire::https::Proxy "http://localhost:9913";
EOF
    fi

    [[ ! -f /etc/apt/sources.list.bak ]] && cp /etc/apt/sources.list /etc/apt/sources.list.bak

    if ! grep -q kakao /etc/apt/sources.list; then
        [[ -f /etc/apt/sources.list.d/ubuntu.sources.bak ]] || cp /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
        sed -i -s -r -e 's/\/kr.archive.ubuntu.com/\/mirror.kakao.com/g' /etc/apt/sources.list.d/ubuntu.sources
        sed -i -s -r -e 's/\/archive.ubuntu.com/\/mirror.kakao.com/g' /etc/apt/sources.list.d/ubuntu.sources
        sed -i -s -r -e 's/\/security.ubuntu.com/\/mirror.kakao.com/g' /etc/apt/sources.list.d/ubuntu.sources
    fi
    apt-get update && apt-get install -y git input-remapper wev tree
fi


###################
# sudoers
###################
if [[ ! -f /etc/sudoers.d/90-additional-users ]]; then
    echo $(logname)' ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-additional-users
    chmod 440 /etc/sudoers.d/90-additional-users
    cat /etc/sudoers.d/90-additional-users
fi
