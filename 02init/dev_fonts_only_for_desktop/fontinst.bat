::RUN with Administrator mode

@echo off
cd %~dp0

:: Windos font directory 
:: set DIRSYSFONT=C:\Windows\Fonts
set DIRSYSFONT=%windir%\fonts
set REG_KEY="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

set DIRACMA=acinema
set DIRNOTO=noto
set ALL=%DIRACMA% %DIRNOTO%

xcopy %DIRACMA%\* %DIRSYSFONT% 
xcopy %DIRNOTO%\* %DIRSYSFONT% 

FOR /F "tokens=* usebackq" %%F IN (`dir /b %ALL%`) DO (
    reg add %REG_KEY% /v "%%~nF (TrueType)" /t REG_SZ /d %%F /f
)

pause
