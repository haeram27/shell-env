#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit 1
fi
 
tar xvf d2coding-132-20180524.txz
tar xvf acinema.txz

find . -type d -exec sudo chmod 755 {} \;
find . -type f -name "*.tt[cf]" -exec sudo chmod 644 {} \;

cp -rf d2coding /usr/share/fonts/truetype
cp -rf acinema /usr/share/fonts/truetype

fc-cache -vf

rm -rf ./d2coding
rm -rf ./acinema
