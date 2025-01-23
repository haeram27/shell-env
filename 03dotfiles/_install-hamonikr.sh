#!/usr/bin/env bash

function install() {
    cp -fb ./bashrc.cust ~/.bashrc.cust
    cp -fb ./zshrc.cust ~/.zshrc.cust
    cp -fb ./alias.cust ~/.alias.cust
    cp -fb ./bindkey.cust ~/.bindkey.cust
    cp -fb ./env.cust ~/.env.cust
    cp -fb ./gitconfig ~/.gitconfig
    cp -fb ./tmux.conf ~/.tmux.conf
    cp -fr ./config/terminator ~/.terminator
    
    echo >> ~/.zshrc
    echo '[[ -f ~/.zshrc.cust ]] && . ~/.zshrc.cust' >> ~/.zshrc
    
    # file mode
    chown -R $(logname): ~/.[^.]*.cust ~/.gitconfig ~/.p10k.zsh ~/.zshrc ~/.config
    chmod -R 644 ~/.[^.]*.cust ~/.gitconfig ~/.p10k.zsh ~/.zshrc ~/.config 
}

read -p "This may overwrite existing your current setting files in home directory. Are you sure? (y/n) " -n 1;
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	install
fi
