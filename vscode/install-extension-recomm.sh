#!/usr/bin/env bash

if [[ -d /home/${USER}/.vscode/extensions ]]; then
  cp ./extensions.recommed.linux.json  /home/${USER}/.vscode/extensions/extensions.json
fi

if [[ -d /home/${USER}/.vscode-server/extensions ]]; then
  cp ./extensions.recommed.linux.json  /home/${USER}/.vscode-server/extensions/extensions.json
fi

