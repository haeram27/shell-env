#!/bin/bash

##########
# RUN THIS COMMAND EXAMPLE:
# sudo NORUNSH=norun_envsetup_wsl_2004.sh ./_1_sudorun_install.sh
##########

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
    exit 1
fi

NORUNSH=norun_envsetup_ubuntu_2404_desktop.sh
if [[ -z "$NORUNSH" ]];then
    echo 'please run with NORUNSH=norun_envsetup_XXX.sh'; exit 1;
else
    echo 'NORUNSH='$NORUNSH
fi


logfile=setup_env_$(date '+%Y%m%d%k%M%S').log

./$NORUNSH 2>&1 | tee $logfile
