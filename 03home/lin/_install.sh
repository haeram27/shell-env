#!/usr/bin/env bash

install() {
    sudo apt-get install -y zsh

    rsync -av ./home ~
    
    echo >> ~/.bashrc
    echo '[[ -f ~/.cust/bashrc.cust ]] && . ~/.cust/bashrc.cust' >> ~/.bashrc
    
    tar xfz ./dotzsh.tgz
    mkdir ~/.zsh; mv ./dotzsh/* ~/.zsh/
    rm -rf ./dotzsh

    # gitstatus dir is required by p10k
    mkdir -p ~/.cache/gitstatus; tar xvf ./gitstatusd-1.5.4-linux-x86_64.tar.gz -C ~/.cache/gitstatus >/dev/null

    # file mode
    chown -R $(id -un): ~/.*.cust ~/.*.conf ~/.gitconfig ~/.p10k.zsh ~/.zshrc ~/.cust
    chmod -R 644 ~/.*.cust ~/.gitconfig ~/.p10k.zsh ~/.zshrc ~/.cust
    rm -f ~/.*~

    chsh -s $(which zsh)
}

read -p "This may overwrite existing your current setting files in home directory. Are you sure? (y/n) " -n 1;
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	install
fi
