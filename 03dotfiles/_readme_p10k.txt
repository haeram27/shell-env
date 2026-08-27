@ configure p10k
> p10k configure

@ show context(user@host) always, block below line with #hsw#
> vi .p10k.zsh
  # Don't show context unless root or in SSH.
  #hsw#typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=
