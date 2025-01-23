#!/usr/bin/env bash

## Example > Single package install from PPA: java
# sudo add-apt-repository ppa:webupd8team/java
# sudo apt-get -y update && apt-get -y install oracle-java8-installer

## Example > Package install from Downloaded deb
# sudo dpkg -i ~/Downloads/ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
# sudo apt-get -y -f install

## Example > Package remove
# sudo apt remove ubuntu-tweak

## Example > Package remove with dependency
# sudo apt purge ubuntu-tweak


################################################### 
## Check TBD to include
################################################### 

# 우분투 클리너 저장소 ~ ppa:gerardpuig/ppa


################################################### 
## setup variable
################################################### 
#logname
myid=$(id -un)


################################################### 
## Repository update and preparation
################################################### 
apt-get -f install; apt-get -y update; apt-get -y upgrade; apt-get clean;


################################################### 
## Install Apps Require User Confirm
################################################### 


################################################### 
## Install System Util
################################################### 

# vim
apt-get -y install vim


# tmux
apt-get -y install tmux


# zsh
apt-get -y install zsh


# autojump
apt-get -y install autojump


# tree
apt-get -y install tree


# htop
apt-get -y install htop


# net-tools (ifconfig)
apt-get -y install net-tools


# xclip
apt-get -y install xclip


# rename
apt-get -y isntall rename


# curl
apt-get -y install curl


# dos2unix
apt-get -y install dos2unix


# batcat
apt-get -y install batcat


# synergy
# apt-get -y install synergy libcanberra-gtk-module sni-qt


# 7z
apt-get -y install p7zip-full


# zip
apt-get -y install unzip


# exfat support lib
apt-get -y install exfat-fuse exfat-utils


# ssh server
apt-get -y install openssh-server


# samba server
apt-get -y install samba


# samba client
apt-get -y install smbclient cifs-utils


# gnome tweak tool
# apt-get -y install gnome-tweak-tool


################################################### 
## Install Dev Toos
################################################### 

# build essential
apt-get -y install build-essential

# cmake
# apt-get -y install cmake

# json command line processor
apt-get -y install jq yq

# ??
# apt-get -y install moreutils

# libcurl
# apt-get -y install libcurl4-openssl-dev

# libzip
# apt-get -y install libzip-dev

# libuuid
# apt-get -y install uuid-dev

# libacl
# apt-get -y install libacl1-dev

# cscope
# apt-get -y install cscope

# ctags
# apt-get -y install ctags


# python3
apt-get -y upgrade python3
python3 --version


# java
# add-apt-repository -y ppa:webupd8team/java
# apt-get -y install oracle-java8-installer
# java -version


# git/svn
# add-apt-repository -y ppa:git-core/ppa
apt-get -y install git-core
apt-get -y install git-svn
apt-get -y install rabbitvcs-cli rabbitvcs-core rabbitvcs-gedit rabbitvcs-nautilus


# wireshark
# add-apt-repository -y ppa:wireshark-dev/stable
# apt-get -y install wireshark


# sqlite browser
# add-apt-repository -y ppa:linuxgndu/sqlitebrowser
# apt-get -y install sqlitebrowser


# kvm
# This is only Lucid (10.04) or later, Command Should be updated after Cosmic (18.10) or later
# apt-get -y install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils  virt-manager
# adduser $(id -un) kvm
# virsh list --all



################################################### 
## Install Desktop Apps
###################################################

# terminator
apt-get -y install terminator



################################################### 
## Install Media Apps
###################################################

# wallch - wallpaper changer
# apt-get -y install wallch

# shutter - screenshot tool  http://shutter-project.org/downloads/
# add-apt-repository -y ppa:shutter/ppa
# apt-get -y install shutter


# mpv for SMPlayer
# add-apt-repository -y ppa:mc3man/mpv-tests
# apt-get -y install mpv


# SMPlayer
# add-apt-repository -y ppa:rvm/smplayer
# apt-get -y install smplayer smtube smplayer-themes smplayer-skins


# gimp
# apt-get -y install gimp

##TBD
#atom
#Android Studio



################################################### 
## Install Auth App
###################################################

# howdy - face recognition authentication for linux
# github.com/boltgolt/howdy
# sudo add-apt-repository ppa:bolt/howdy
# sudo apt update
# sudo apt install howdy




################################################### 
## remove unused depencies
###################################################

apt-get autoremove


################################################### 
# System Setting
###################################################

# make large size of inotify of filesystem :: for Android studio file search
cp /etc/sysctl.d/99-sysctl.conf  /etc/sysctl.d/99-sysctl.conf.bak
sh -c 'printf "fs.inotify.max_user_watches = 524288\n" > /etc/sysctl.d/99-sysctl.conf'


