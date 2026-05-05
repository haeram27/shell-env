#!/usr/bin/env bash
cp -f ./dotfzf.bash ~/.fzf.bash
cp -f ./dotfzf.zsh ~/.fzf.zsh

cp -rf ./fzf-master* ~/.fzf
chmod -R 755 ~/.fzf
find ~/.fzf -type f ! -name '*.sh' -print0 | xargs -0 chmod 644
