#!/bin/bash

tar xvf acinema.txz
tar xvf d2coding132.txz
tar xvf meslo.txz
tar xvf windows.txz

chmod -R 755 ./

cp -rf acinema /usr/share/fonts/truetype
cp -rf d2coding /usr/share/fonts/truetype
cp -rf meslo /usr/share/fonts/truetype
cp -f ./etc_fonts_local.conf /etc/fonts/local.conf
chmod 644 /etc/fonts/local.conf

fc-cache -vf

rm -rf ./acinema
rm -rf ./d2coding
rm -rf ./meslo
rm -rf ./windows
