#!/usr/bin/env bash

TARGET="/home/${USER}/.vscode/extensions"
if [[ -d $TARGET ]]; then
  cp $TARGET/extensions.json $TARGET/extensions.json.bak
  cp ./extensions.recommed.linux.json $TARGET/extensions.json
fi


