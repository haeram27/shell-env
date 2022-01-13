#!/bin/bash

chmod -R 755 ./

cp -rf d2coding /usr/share/fonts/truetype
cp -rf meslo /usr/share/fonts/truetype
cp -rf windows  /usr/share/fonts/truetype

fc-cache -vf
