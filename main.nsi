;BL-Browser for Blockland
;NSIS Script
;Written by https://github.com/paperworx

;------------------------------
;Plugins

!addplugindir "plugins"

;------------------------------
;Headers

!include "LogicLib.nsh"
!include "WinVer.nsh"
!include "FileFunc.nsh"
!insertmacro GetDrives

;------------------------------
;Defines

!define PRODUCT_NAME "BL-Browser for Blockland"
!define PRODUCT_VERSION "0.2.1"
!define FILE_VERSION "1.2.0"

;------------------------------
;General

SetCompressor /SOLID lzma

Name "${PRODUCT_NAME} v${FILE_VERSION}"
OutFile "BL-Browser.${FILE_VERSION}.Installer.exe"

VIProductVersion "${PRODUCT_VERSION}.0"
VIFileVersion "${FILE_VERSION}.0"
VIAddVersionKey "FileVersion" "${FILE_VERSION}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "FileDescription" "${PRODUCT_NAME}"
VIAddVersionKey "LegalCopyright" ""

RequestExecutionLevel user

LicenseText "Please read the information below before installing BL-Browser for Blockland." "OK"
LicenseData "info.txt"
LicenseBkColor /windows
SubCaption 0 ": Read Me"

CRCCheck force
SetDateSave off
AllowSkipFiles off

;------------------------------
;Pages

Page license
Page directory directoryFindBlockland
Page instfiles "" "" instfilesLeave

;------------------------------
;Functions

Function .onInit
  ${IfNot} ${AtLeastWin7}
    MessageBox MB_OK|MB_ICONSTOP "BL-Browser will not work on operating systems prior to Windows 7, please upgrade your operating system."
    Quit
  ${EndIf}

  IfFileExists "$WINDIR\System32\msvcr120.dll" +3 0
    MessageBox MB_OK|MB_USERICON "Missing MSVCR120.dll$\r$\n$\r$\nPlease install Microsoft Visual C++ Runtime Redistributable 2013 (x86) from https://www.microsoft.com/en-us/download/details.aspx?id=40784"
    Quit

  IfFileExists "$WINDIR\System32\vcruntime140.dll" +3 0
    MessageBox MB_OK|MB_USERICON "Missing VCRUNTIME140.dll$\r$\n$\r$\nPlease install Microsoft Visual C++ Runtime Redistributable 2017 (x86) from https://go.microsoft.com/fwlink/?LinkId=746571"
    Quit
FunctionEnd

Function directoryFindBlockland
  IfFileExists "$PROGRAMFILES\Steam\steamapps\common\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$PROGRAMFILES\Steam\steamapps\common\Blockland"
    Goto directoryFound

  StrCpy $R3 ""

  ${GetDrives} "HDD" "directoryFindSteamLibrary"

  StrCmp $R3 "" +3 0
    StrCpy $INSTDIR $R3
    Goto directoryFound

  IfFileExists "$DOCUMENTS\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$DOCUMENTS\Blockland"
    Goto directoryFound

  IfFileExists "$PROGRAMFILES\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$PROGRAMFILES\Blockland"
    Goto directoryFound

  IfFileExists "$DESKTOP\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$DESKTOP\Blockland"
    Goto directoryFound

  MessageBox MB_OK|MB_ICONEXCLAMATION "Could not locate a Blockland game folder automatically, please find it yourself."
  Goto +3

  directoryFound:

  MessageBox MB_OK|MB_ICONINFORMATION "A Blockland game folder was found automatically, if this is the folder you were expecting then you can just press Install on the following window."
FunctionEnd

Function directoryFindSteamLibrary
  IfFileExists "$9SteamLibrary\steamapps\common\Blockland\*.*" 0 +3
    StrCpy $R3 "$9SteamLibrary\steamapps\common\Blockland"
    StrCpy $0 StopGetDrives

  Push $0
FunctionEnd

Function instfilesLeave
  IfAbort 0 +3
    MessageBox MB_OK|MB_ICONSTOP "Installation has been aborted."
    Quit
FunctionEnd

Function .onVerifyInstDir
  IfFileExists "$INSTDIR\Blockland.exe" +2 0
    Abort
FunctionEnd

;------------------------------
;Sections

Section
  SetDetailsView show

  FindProcDLL::FindProc "Blockland.exe"

  IntCmp $R0 1 0 +9
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "Blockland must be closed before continuing, press OK to terminate program or Cancel to abort the installation." IDOK +2 IDCANCEL 0
    Abort
    DetailPrint "Terminating Blockland.exe..."
    KillProcDLL::KillProc "Blockland.exe"
    Sleep 1000
    IntCmp $R0 0 +3 0
      MessageBox MB_OK|MB_ICONEXCLAMATION "Failed to terminate Blockland.exe"
      Abort

  IfFileExists "$INSTDIR\Blockland.exe.backup" +4 0
    DetailPrint "Backing up original Blockland.exe..."
    CopyFiles /SILENT "$INSTDIR\Blockland.exe" "$INSTDIR\Blockland.exe.backup"
    Goto +2
    DetailPrint "Backup of Blockland.exe already exists, skipping..."

  SetOutPath $INSTDIR
  File /r "instfiles\*.*"
  File "Uninstall BL-Browser.bat"

  DetailPrint "Setting Blockland.exe to read-only..."
  SetFileAttributes "$INSTDIR\Blockland.exe" READONLY

  MessageBox MB_OK|MB_ICONINFORMATION "Please remember to apply the following settings in your Blockland options:$\r$\n$\r$\n- Texture Quality set to HIGH or above.$\r$\n- Download Textures set to ENABLED."
SectionEnd