#!/bin/bash

##########
# RUN THIS COMMAND EXAMPLE:
# sudo NORUNSH=norun_envsetup_wsl_2004.sh ./_1_sudorun_inst.sh
##########

if [[ -z "$NORUNSH" ]];then
    echo 'please run with NORUNSH=norun_envsetup_XXX.sh'; exit -1;
else
    echo 'NORUNSH = ' $NORUNSH
fi

#if ! grep -q kakao /etc/apt/sources.list; then
#    cp /etc/apt/sources.list /etc/apt/sources.list.$(date '+%Y%m%d%k%M%S').bak
#    sed -i -s -r -e 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
#    sed -i -s -r -e 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
#fi
apt-get update; apt-get upgrade -y;


logfile=setup_env_$(date '+%Y%m%d%k%M%S').log

pushd dev_fonts
./fontinstwsl.sh 2>&1 | tee -a ../$logfile
popd

./$NORUNSH 2>&1 | tee $logfile
