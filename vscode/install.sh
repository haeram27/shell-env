#!/usr/bin/env bash

[[ -d /home/${USER}/.vscode/data/Machine ]] && \
cp ./linux.settings.json   /home/${USER}/.vscode/data/Machine/settings.json 
[[ -d /home/${USER}/.vscode-server/data/Machine ]] && \
cp ./linux.settings.json   /home/${USER}/.vscode-server/data/Machine/settings.json 
cp -r ./style-guide /home/${USER}/.vscode-server/ 

