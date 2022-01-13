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
#myid=$(whoami)  ## this print 'root'
#myid=$(logname)  ## this print ?
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


# htop
apt-get -y install htop


# net-tools (ifconfig)
apt-get -y install net-tools


# xclip
apt-get -y install xclip


# rename
apt-get -y install rename


# curl
apt-get -y install curl


# dos2unix
apt-get -y install dos2unix


# 7z
apt-get -y install p7zip-full


# exfat support lib
apt-get -y install exfat-fuse exfat-utils


################################################### 
## Install Dev Toos
################################################### 

# build essential
apt-get -y install build-essential

# cmake
apt-get -y install cmake

# json command line processor
apt-get -y jq

# ??
apt-get -y install moreutils

# libcurl
apt-get -y install libcurl4-openssl-dev

# libzip
apt-get -y install libzip-dev

# libuuid
apt-get -y install uuid-dev

# libacl
apt-get -y install libacl1-dev


# cscope
apt-get -y install cscope

# ctags
apt-get -y install ctags

# python3
apt-get -y upgrade python3
python3 --version


# git/svn
# add-apt-repository -y ppa:git-core/ppa
apt-get -y install git-core git-svn


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





