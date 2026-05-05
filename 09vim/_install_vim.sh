#!/usr/bin/env bash
tar zxvf ./dotvim.tgz
rm -rf ~/.vim
mv ./dotvim ~/.vim
cp -f ./dotvimrc ~/.vimrc

chmod 700 ~/.vim
chmod 644 ~/.vimrc

