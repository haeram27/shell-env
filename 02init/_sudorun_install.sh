#!/bin/bash

##########
# RUN THIS COMMAND EXAMPLE:
# sudo NORUNSH=norun_envsetup_wsl_2004.sh ./_1_sudorun_install.sh
##########

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

if [[ -z "$NORUNSH" ]];then
    echo 'Usage:';
    echo '    sudo -E NORUNSH=norun_envsetup_XXX.sh ./_sudorun_install.sh';
    exit 1;
else
    echo 'NORUNSH='$NORUNSH
fi


logfile=setup_env_$(date '+%Y%m%d%k%M%S').log

./$NORUNSH 2>&1 | tee $logfile
