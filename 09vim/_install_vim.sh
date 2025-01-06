#!/usr/bin/env bash
tar zxvf ./dotvim.tgz
cp -rf ./dotvim ~/.vim
cp -f ./dotvimrc ~/.vimrc
rm -rf ./dotvim

chmod 700 ~/.vim
chmod 644 ~/.vimrc

