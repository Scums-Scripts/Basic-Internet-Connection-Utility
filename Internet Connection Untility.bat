@echo off
title Internet Connection Utility
color 0A
setlocal DisableDelayedExpansion

:: Define Colors
:: 0A - Bright Green (Hacker Style)
:: 0C - Red (Errors)
:: 0E - Yellow (Warnings)
:: 0B - Cyan (Info)

:menu
cls
echo ====================================================
echo          Internet Connection Utility Tool
echo ====================================================
echo.
echo  [1] Check Internet Connection Status
echo  [2] Enhance Internet Connection Performance
echo  [3] Exit
echo.
echo ====================================================
set /p choice=Enter your choice (1/2/3): 

if "%choice%"=="1" goto check_status
if "%choice%"=="2" goto enhance_performance
if "%choice%"=="3" exit

color 0C
echo Invalid choice. Please try again.
color 0A
pause
goto menu

:: ----------------------------

:check_status
cls
color 0A
echo ====================================================
echo          Checking Internet Connection Status
echo ====================================================
echo.
echo Sending traceroute to Google.com...
echo.
powershell -Command "& { tracert google.com }"
echo.
echo Sending ping test to Google.com...
echo.
powershell -Command "& { ping google.com }"
echo.
echo Displaying network adapter configuration...
echo.
powershell -Command "& { ipconfig /all }"
echo.
echo ====================================================
color 0A
pause
goto menu

:: ----------------------------

:enhance_performance
cls
color 0A
echo ====================================================
echo          Enhancing Internet Performance
echo ====================================================
echo.
echo This will apply optimizations to improve network speed.
echo Some changes require administrative privileges.
echo ====================================================
echo.

:: Check and request Admin rights
if not "%1"=="am_admin" (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\" am_admin' -Verb RunAs"
    exit
)

color 0A
echo Disabling Auto-Tuning...
powershell -Command "& { netsh interface tcp set global autotuning=disabled }"

echo Disabling TCP Heuristics...
powershell -Command "& { netsh interface tcp set heuristics disabled }"

echo Enabling TCP Chimney Offload...
powershell -Command "& { netsh int tcp set global chimney=enabled }"

echo Enabling Direct Cache Access (DCA)...
powershell -Command "& { netsh int tcp set global dca=enabled }"

echo Enabling Network Direct Memory Access (NetDMA)...
powershell -Command "& { netsh int tcp set global netdma=enabled }"

echo Enabling Explicit Congestion Notification (ECN)...
powershell -Command "& { netsh int tcp set global ecncapability=enabled }"

color 0A
echo Resetting TCP/IP settings...
powershell -Command "& { netsh int ip reset }"

echo Resetting WinSock...
powershell -Command "& { netsh winsock reset }"

echo Flushing DNS cache...
powershell -Command "& { ipconfig /flushdns }"

echo Releasing IP Address...
powershell -Command "& { ipconfig /release }"

echo Renewing IP Address...
powershell -Command "& { ipconfig /renew }"

color 0C
echo.
echo.
echo.
echo Restart your computer for changes to take effect.
echo ====================================================
color 0A
pause
goto menu
