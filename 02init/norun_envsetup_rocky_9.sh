#!/usr/bin/env bash

## Example > Single package install from PPA: java
# sudo add-apt-repository ppa:webupd8team/java
# sudo dnf -y update && dnf -y install oracle-java8-installer

## Example > Package install from Downloaded deb
# sudo dpkg -i ~/Downloads/ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
# sudo dnf -y -f install

## Example > Package remove
# sudo dnf remove ubuntu-tweak

## Example > Package remove with dependency
# sudo dnf purge ubuntu-tweak



################################################### 
## setup variable
################################################### 
#myid=$(whoami)  ## this print 'root'
#myid=$(logname)  ## this print ?
myid=$(id -un)



################################################### 
## Install Apps Require User Confirm
################################################### 


################################################### 
## Install System Util
################################################### 
# epel
dnf -y install epel-release

# vim
dnf -y install vim


# tmux
dnf -y install tmux


# zsh
dnf -y install zsh


# fzf - fuzzy finder
dnf -y install fzf


# zoxide - change directory util - https://github.com/ajeetdsouza/zoxide
dnf -y install zoxide


# top
dnf -y install btop htop glances


# curl
dnf -y install curl


# dos2unix
dnf -y install dos2unix


################################################### 
## Install Dev Toos
################################################### 


# json command line processor
dnf -y install jq yq


# ctags
#dnf -y install ctags

# python3
dnf -y upgrade python3
python3 --version


# git/svn
# add-apt-repository -y ppa:git-core/ppa
dnf -y install git-core git-svn


################################################### 
## remove unused depencies
###################################################
dnf autoremove


################################################### 
# System Setting
###################################################

# make large size of inotify of filesystem :: for Android studio file search
# [[ ! -s /etc/sysctl.d/99-sysctl.conf.origin ]] && cp /etc/sysctl.d/99-sysctl.conf  /etc/sysctl.d/99-sysctl.conf.origin
# sh -c 'printf "fs.inotify.max_user_watches = 1048576\n" > /etc/sysctl.d/99-sysctl.conf'

