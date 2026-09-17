#!/usr/bin/env bash

install() {
    sudo apt-get install -y zsh

    rsync -av ./home/ ~
    
    echo >> ~/.bashrc
    echo '[[ -f ~/.bashrc.cust ]] && . ~/.bashrc.cust' >> ~/.bashrc

    # zsh
    tar xfz ./dotzsh.tgz
    rm -rf ~/.zsh
    mv ./dotzsh ~/.zsh
    
    # vim
    tar zxvf ./dotvim.tgz
    rm -rf ~/.vim
    mv ./dotvim ~/.vim
    chmod 700 ~/.vim

    # gitstatus dir is required by p10k
    mkdir -p ~/.cache/gitstatus; tar xvf ./gitstatusd-1.5.4-linux-x86_64.tar.gz -C ~/.cache/gitstatus >/dev/null

    # file mode
    chown -R $(id -un): ~/.*.cust ~/.*.conf ~/.gitconfig ~/.p10k.zsh ~/.zshrc
    chmod -R 600 ~/.*.cust ~/.gitconfig ~/.p10k.zsh ~/.zshrc 
    chmod -R 700 ~/.cust ~/.ssh ~/.swutil ~/.cache ~/.config
    rm -f ~/.*~

    chsh -s $(which zsh)
}

read -p "This may overwrite existing your current setting files in home directory. Are you sure? (y/n) " -n 1;
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	install
fi
