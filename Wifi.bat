@echo off
cls


setlocal enabledelayedexpansion
set "print="

for /f "usebackq delims=" %%A in ("%~f0") do (
    if "%%A"=="::ascii" (
        set "print=1"
        rem 
    ) else if "%%A"=="::endascii" (
        set "print="
    ) else (
        if defined print echo %%A
    )
)
endlocal

echo.


for /f "tokens=2 delims=:" %%A in ('netsh wlan show interfaces ^| findstr "SSID" ^| findstr /v "BSSID"') do (
    set ssid=%%A
)


set ssid=%ssid:~1%


for /f "tokens=2 delims=:" %%B in ('netsh wlan show profile name^="%ssid%" key^=clear ^| findstr "Key Content"') do (
    set password=%%B
)


set password=%password:~1%


echo Wi-Fi Name    : %ssid%
echo Wi-Fi Password: %password%
echo.

pause
goto :eof

::ascii
           ___
        .';:;'.
       /_' _' /\   __
       ;a/ e= J/-'"  '.
       \ ~_   (  -'  ( ;_ ,.
        L~"'_.    -.  \ ./  )
        ,'-' '-._  _;  )'   (
      .' .'   _.'")  \  \(  |    Wifi-Gollumn
     /  (  .-'   __\{`', \  |  @Bornelabs papers     
    / .'  /  _.-'   "  ; /  |   
   / /    '-._'-,     / / \ (
 __/ (_    ,;' .-'    / /  /_'-._
`"-'` ~`  ccc.'   __.','     \j\L\
                 .='/|\7      
                     ' `
::endascii
