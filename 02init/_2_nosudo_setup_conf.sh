################################################### 
## variable
################################################### 
myid=$(whoami)

# terminator user conf
test -d ~/.config/terminator || mkdir -p ~/.config/terminator
cp -b ./conf/terminator/config ~/.config/terminator/config
chown -R $myid:$myid ~/.config/terminator
chmod 664 ~/.config/terminator/config

