#!/usr/bin/env bash

 install() {
    sudo apt-get install -y zsh

    cp -fb ./bashrc.cust ~/.bashrc.cust
    cp -fb ./p10k.zsh ~/.p10k.zsh
    cp -fb ./zshrc ~/.zshrc
    cp -fb ./zshrc.cust ~/.zshrc.cust
    cp -fb ./alias.cust ~/.alias.cust
    cp -fb ./bindkey.cust ~/.bindkey.cust
    cp -fb ./env.cust ~/.env.cust
    cp -fb ./gitconfig ~/.gitconfig
    cp -fb ./tmux.conf ~/.tmux.conf
    [[ ! -d ~/.config ]] && mkdir ~/.config
    cp -fr ./config/* ~/.config
    
    echo >> ~/.bashrc
    echo '[[ -f ~/.bashrc.cust ]] && . ~/.bashrc.cust' >> ~/.bashrc
    
    tar xfz ./dotzsh.tgz
    mkdir ~/.zsh; mv ./dotzsh/* ~/.zsh/
    rm -rf ./dotzsh

    # gitstatus dir is required by p10k
    mkdir -p ~/.cache/gitstatus; tar xvf ./gitstatusd-1.5.4-linux-x86_64.tar.gz -C ~/.cache/gitstatus >/dev/null

    # file mode
    chown -R $(id -un): ~/.*.cust ~/.*.conf ~/.gitconfig ~/.p10k.zsh ~/.zshrc
    chmod -R 644 ~/.*.cust ~/.gitconfig ~/.p10k.zsh ~/.zshrc
    rm -f ~/.*~

    chsh -s $(which zsh)
}

read -p "This may overwrite existing your current setting files in home directory. Are you sure? (y/n) " -n 1;
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	install
fi
