#!/usr/bin/env bash

function install() {
    cp -fb ./bashrc.cust ~/.bashrc.cust
    cp -fb ./p10k.zsh ~/.p10k.zsh
    cp -fb ./zshrc ~/.zshrc
    cp -fb ./zshrc.cust ~/.zshrc.cust
    cp -fb ./alias.cust ~/.alias.cust
    cp -fb ./bindkey.cust ~/.bindkey.cust
    cp -fb ./env.cust ~/.env.cust
    cp -fb ./gitconfig ~/.gitconfig

    echo >> ~/.bashrc
	echo '[[ -f ~/.bashrc.cust ]] && . ~/.bashrc.cust' >> ~/.bashrc
    
    echo >> ~/.zshrc
	echo '[[ -f ~/.zshrc.cust ]] && . ~/.zshrc.cust' >> ~/.zshrc
    
    tar xvfz ./dotzsh.tgz
    mkdir ~/.zsh; mv ./dotzsh/* ~/.zsh/
    rm -rf ./dotzsh

    # gitstatus dir is required by p10k
    tar xvfz ./gitstatus.tgz
    mkdir ~/.cache; mv ./gitstatus ~/.cache/

    chmod 644 ~/.[^.]*.cust ~/.gitconfig ~/.p10k.zsh ~/.zshrc
    chmod 700 ~/.zsh

    chsh -s $(which zsh)
}

read -p "This may overwrite existing your current setting files in home directory. Are you sure? (y/n) " -n 1;
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	install
fi
