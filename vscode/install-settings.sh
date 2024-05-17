#!/usr/bin/env bash

if [[ -d /home/${USER}/.vscode/data/Machine ]]; then
  cp ./linux.settings.json   /home/${USER}/.vscode/data/Machine/settings.json
fi

if [[ -d /home/${USER}/.vscode-server/data/Machine ]]; then
  cp ./linux.settings.json   /home/${USER}/.vscode-server/data/Machine/settings.json 
  cp -r ./style-guide /home/${USER}/.vscode-server/
fi

