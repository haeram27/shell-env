#!/usr/bin/env bash
set -x

if [[ -d /home/${USER}/.config/Code/User ]]; then
  cp ./linux.settings.json   /home/${USER}/.config/Code/User/settings.json
  cp -r ./style-guide /home/${USER}/.config/Code/User
fi


if [[ -d /home/${USER}/.vscode-server ]]; then
  mkdir -p /home/${USER}/.vscode-server/data/Machine
  cp ./linux.settings.json   /home/${USER}/.vscode-server/data/Machine/settings.json 
  cp -r ./style-guide /home/${USER}/.vscode-server
fi

# install extensions
extensions=(
    "adamhartford.vscode-base64"
    "dotjoshjohnson.xml"
    "earshinov.filter-lines"
    "golang.go"
    "jhasse.bracket-select2"
    "mhutchie.git-graph"
    "ms-vscode.cpptools"
    "ms-vscode.cpptools-themes"
    "mtxr.sqltools"
    "oderwat.indent-rainbow"
    "redhat.java"
    "redhat.vscode-yaml"
    "visualstudioexptteam.intellicode-api-usage-examples"
    "visualstudioexptteam.vscodeintellicode"
    "vscjava.vscode-gradle"
    "vscjava.vscode-java-debug"
    "vscjava.vscode-java-dependency"
    "vscjava.vscode-java-pack"
    "vscjava.vscode-java-test"
    "vscjava.vscode-lombok"
    "vscjava.vscode-maven"
    "vscode-icons-team.vscode-icons"
    "yzhang.markdown-all-in-one"
)

for extension in "${extensions[@]}"; do
    code --install-extension "$extension"
done
