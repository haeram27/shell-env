# How to run

1. Setup to run downloaded .ps1 files 
```ps1
# Set policy to allow run downloaded .ps1 script
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Get-ExecutionPolicy -List

# Remove ZoneIdentifier of .ps1 script files in directory
Get-ChildItem -Recurse -Filter *.ps1 | Unblock-File
Get-Item ./install_tools.ps1 -Stream *
```

2. Setup to run downloaded .ps1 files 
```ps1
01_install_tools.ps1
02_configure-home.ps1
03_register-env.ps1
```
