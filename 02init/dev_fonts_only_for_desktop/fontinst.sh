#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

# Load OS information
if [ -f /etc/os-release ]; then
    . /etc/os-release

    # Check ID or ID_LIKE for Debian/Ubuntu or RHEL
    if [[ "$ID" == "debian" || "$ID" == "ubuntu" || "$ID_LIKE" == *"debian"* ]]; then
        echo "Detected Debian/Ubuntu based system..."
        sudo apt update -y
        sudo apt install -y fonts-noto-mono fonts-noto-cjk fonts-noto-color-emoji

    elif [[ "$ID" == "rhel" || "$ID" == "fedora" || "$ID_LIKE" == *"rhel"* || "$ID_LIKE" == *"fedora"* ]]; then
        echo "Detected RHEL based system..."
        sudo dnf update -y
        sudo dnf install -y google-noto-fonts-common google-noto-sans-cjk-fonts google-noto-color-emoji-fonts

    else
        echo "Unsupported distribution: $ID"
        tar xvf acinema.txz
        tar xvf noto.txz

        find . -type d -exec sudo chmod 755 {} \;
        find . -type f -name "*.tt[cf]" -exec sudo chmod 644 {} \;

        cp -rf acinema /usr/share/fonts/truetype
        cp -rf noto  /usr/share/fonts/truetype

        fc-cache -vf

        rm -rf ./acinema
        rm -rf ./noto
    fi
fi