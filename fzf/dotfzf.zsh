# Setup fzf
# ---------
if [[ ! "$PATH" == */home/swhwang/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/swhwang/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/swhwang/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/swhwang/.fzf/shell/key-bindings.zsh"
