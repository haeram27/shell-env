#!/bin/bash

if (( $EUID != 0 )); then
    echo "This script must be run as root"
    exit 1
fi

###################
# sudoers
###################
if [[ ! -f /etc/sudoers.d/90-additional-users ]]; then
    echo $(logname)' ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-additional-users
    chmod 440 /etc/sudoers.d/90-additional-users
    cat /etc/sudoers.d/90-additional-users
fi
