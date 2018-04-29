@echo off

REM This file was added by the BL-Browser installer.
REM Source: https://github.com/paperworx/BL-Browser-Installer

title BL-Browser Uninstaller

color 1f

echo Continuing will remove BL-Browser from the current Blockland directory, and revert your Blockland.exe to the state it was in prior to install.
echo.
echo ** If Blockland is running, the program will be terminated immediately. **
echo.

pause

cls

if not exist Blockland.exe (
  color cf
  echo Blockland.exe not found in current directory, are you sure you're running this from the right location!?
  echo.
  pause
  exit
)

if not exist Blockland.exe.backup (
  color cf
  echo Blockland.exe.backup not found in current directory, unable to restore Blockland.exe to prior state.
  echo.
  pause
  exit
)

taskkill /f /im Blockland.exe
timeout /t 3 /nobreak
echo.

del /q /f avcodec-53.dll
del /q /f avformat-53.dll
del /q /f avutil-51.dll
del /q /f awesomium.dll
del /q /f awesomium_pak_utility.exe
del /q /f awesomium_process.exe
del /q /f icudt.dll
del /q /f inspector.pak
del /q /f libEGL.dll
del /q /f libGLESv2.dll
del /q /f xinput9_1_0.dll
del /q /f Blockland.exe
copy /y Blockland.exe.backup Blockland.exe > nul
del /q /f Blockland.exe.backup
del /q /f modules\AwsHook.dll
if exist \Awesomium (
  rmdir /s /q Awesomium
)

color 2f

echo BL-Browser has been uninstalled!

timeout /t 2 /nobreak

(goto) 2>nul & del "%~f0"