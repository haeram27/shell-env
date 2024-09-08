@echo off
@rem C:\Users\<user-name>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
@rem netstat -n
@rem tasklist /fi "IMAGENAME eq ssh.exe"
@rem taskkill /f /t /im ssh.exe

@rem socks5
start /B ssh -fCN -D localhost:9999 testpub.nat.proxy -o ExitOnForwardFailure=yes -o ServerAliveInterval=60 -o ServerAliveCountMax=10
@rem http.fwd.proxy
start /B ssh -fCN -L 9913:192.168.10.1:34253 testpub.nat.proxy -o ExitOnForwardFailure=yes -o ServerAliveInterval=60 -o ServerAliveCountMax=10
