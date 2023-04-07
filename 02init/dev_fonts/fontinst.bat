::RUN with Administrator mode
::swhwang

@echo off
cd %~dp0

:: Windos font directory 
:: set DIRSYSFONT=C:\Windows\Fonts
set DIRSYSFONT=%windir%\fonts
set REG_KEY="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

set DIRD2=d2coding
set DIRMES=meslo
set ALL=%DIRD2% %DIRMES%

xcopy %DIRD2%\* %DIRSYSFONT% 

FOR /F "tokens=* usebackq" %%F IN (`dir /b %ALL%`) DO (
reg add %REG_KEY% /v "%%~nF (TrueType)" /t REG_SZ /d %%F /f
)

pause
