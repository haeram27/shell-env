#!/usr/bin/env bash

function install() {
    sudo cp -fb ./java-env.sh /etc/profile.d/
}

install
