#!/bin/bash

tar xvf d2coding.txz
tar xvf meslo.txz
tar xvf windows.txz

chmod -R 755 ./

cp -rf d2coding /usr/share/fonts/truetype
cp -rf meslo /usr/share/fonts/truetype
cp -rf windows  /usr/share/fonts/truetype

fc-cache -vf

rm -rf ./d2coding
rm -rf ./meslo
rm -rf ./windows
