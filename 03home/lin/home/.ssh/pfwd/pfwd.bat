@echo off
@rem C:\Users\<user-name>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
@rem netstat -n | findstr 9999
@rem tasklist /fi "IMAGENAME eq ssh.exe"
@rem taskkill /f /t /im ssh.exe

@rem socks5(L4) - socks5h://PROXY_IP:PORT
@rem @rem proxytest = curl -kvx socks5h://PROXY_IP:PORT https://github.com
start /B ssh -fCN -D localhost:9999 testpub.nat.proxy -o ExitOnForwardFailure=yes -o ServerAliveInterval=60 -o ServerAliveCountMax=10

@rem http.fwd.proxy(L7) - http://PROXY_IP:PORT
@rem @rem proxytest = curl -kvx PROXY_IP:PORT https://github.com
start /B ssh -fCN -L 9913:192.168.10.1:34253 testpub.nat.proxy -o ExitOnForwardFailure=yes -o ServerAliveInterval=60 -o ServerAliveCountMax=10
