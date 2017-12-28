;BL-Browser for Blockland
;NSIS Script
;Written by https://github.com/paperworx

;------------------------------
;Plugins

!addplugindir "plugins\"

;------------------------------
;Headers

!include "FileFunc.nsh"
!insertmacro GetDrives

;------------------------------
;General

SetCompressor bzip2

Name "BL-Browser for Blockland"
OutFile "BL-Browser.exe"

RequestExecutionLevel user

LicenseText "Please read the information below before installing BL-Browser for Blockland." "OK"
LicenseData "readme.txt\"
SubCaption 0 ": Read Me"

CRCCheck force
SetDateSave off
AllowSkipFiles off

VIFileVersion "1.0.1.0"
VIProductVersion "0.2.1.0"
VIAddVersionKey "ProductName" "BL-Browser for Blockland"
VIAddVersionKey "FileDescription" "Adds support for web content in Blockland."
VIAddVersionKey "ProductVersion" "0.2.1"

;------------------------------
;Pages

Page license
Page directory directoryFindBlockland
Page instfiles "" "" instfilesLeave

;------------------------------
;Functions

Function directoryFindBlockland
  IfFileExists "$DOCUMENTS\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$DOCUMENTS\Blockland\"
    Goto directoryFound

  IfFileExists "$PROGRAMFILES\Steam\steamapps\common\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$PROGRAMFILES\Steam\steamapps\common\Blockland\"
    Goto directoryFound

  IfFileExists "$PROGRAMFILES\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$PROGRAMFILES\Blockland\"
    Goto directoryFound

  StrCpy $R3 ""

  ${GetDrives} "HDD" "directoryFindSteamLibrary"

  StrCmp $R3 "" +3 0
    StrCpy $INSTDIR $R3
    Goto directoryFound

  IfFileExists "$DESKTOP\Blockland\*.*" 0 +3
    StrCpy $INSTDIR "$DESKTOP\Blockland\"
    Goto directoryFound

  MessageBox MB_OK|MB_ICONEXCLAMATION "Could not locate Blockland game folder automatically, please find it yourself."
  Goto +3

  directoryFound:

  MessageBox MB_OK|MB_ICONINFORMATION "Blockland game folder was found automatically, if this is the folder you were expecting then you can just press Install on the following window."
FunctionEnd

Function directoryFindSteamLibrary
  IfFileExists "$9SteamLibrary\steamapps\common\Blockland\*.*" 0 +3
    StrCpy $R3 "$9SteamLibrary\steamapps\common\Blockland\"
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
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "Blockland must be closed before continuing, press OK to terminate program." IDOK +2 IDCANCEL 0
    Abort
    DetailPrint "Terminating Blockland.exe ..."
    KillProcDLL::KillProc "Blockland.exe"
    Sleep 1000
    IntCmp $R0 0 +3 0
      MessageBox MB_OK|MB_ICONEXCLAMATION "Failed to terminate Blockland.exe"
      Abort

  SetOutPath $INSTDIR
  File /r "instfiles\"

  DetailPrint "Setting Blockland.exe to read-only..."
  SetFileAttributes "$INSTDIR\Blockland.exe" READONLY
SectionEnd