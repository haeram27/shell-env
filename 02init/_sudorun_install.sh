#!/bin/bash

##########
# RUN THIS COMMAND EXAMPLE:
# sudo NORUNSH=norun_envsetup_wsl_2004.sh ./_1_sudorun_install.sh
##########

if (( $EUID != 0 )); then
    echo "This script must be run as root"
    exit 3
fi

if [[ -z "$NORUNSH" ]];then
    echo 'Usage:';
    echo '    sudo -E NORUNSH=norun_envsetup_XXX.sh ./_sudorun_install.sh';
    exit -1;
else
    echo 'NORUNSH = ' $NORUNSH
fi


logfile=setup_env_$(date '+%Y%m%d%k%M%S').log

pushd dev_fonts
./fontinstwsl.sh 2>&1 | tee -a ../$logfile
popd

./$NORUNSH 2>&1 | tee $logfile
