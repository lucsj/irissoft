
# -------------------------------------------------------------------
# Set Working Directory
# -------------------------------------------------------------------

!cd "C:\Program Files\MuldeR's Freeware\SFX Tool v1.01\Resources"


# -------------------------------------------------------------------
# Define Variables
# -------------------------------------------------------------------

var STARTMENU_FOLDER


# -------------------------------------------------------------------
# Choosing Compressor
# -------------------------------------------------------------------

SetCompressor LZMA
SetCompressorDictSize 32
SetCompress Auto
SetDatablockOptimize On


# -------------------------------------------------------------------
# SFX Definitions
# -------------------------------------------------------------------

!define SFX_AppID "{2D821B39-8784-4F3A-9274-86513B73B53D}"; a unique ID for your SFX (It's real GUID)
!define SFX_BaseDir "C:\Program Files\MuldeR's Freeware\SFX Tool v1.01"; the SFX Tool install folder - do NOT edit!
!define SFX_Title "UniversalReloader_0.03_installer"; the installer title
!define SFX_InstallDir "$PROGRAMFILES\UniversalReloader"; the *default* destination directory
!define SFX_OutFile "C:\installation\UniversalReloader_0.03_install.exe"; the file to save the installer EXE to
!define SFX_IconFile "Modern-Default"; the installer icon
!define SFX_HeaderImage "NSIS"; the herader image
!define SFX_WizardImage "Llama"; the wizard image


# -------------------------------------------------------------------
# Reserve Files
# -------------------------------------------------------------------

ReserveFile "Plugins\InstallOptions.dll"
ReserveFile "Plugins\LangDLL.dll"
ReserveFile "Plugins\StartMenu.dll"
ReserveFile "Plugins\UserInfo.dll"
ReserveFile "Contrib\Graphics\Wizard\${SFX_WizardImage}.bmp"
ReserveFile "Contrib\Graphics\Header\${SFX_HeaderImage}.bmp"
ReserveFile "Contrib\Graphics\Header\${SFX_HeaderImage}-R.bmp"
ReserveFile "Contrib\Modern UI\ioSpecial.ini"


# -------------------------------------------------------------------
# General Settings
# -------------------------------------------------------------------

XPStyle On
CRCCheck Force
ShowInstDetails Show
ShowUninstDetails Show
BrandingText "SFX Tool v1.01, NSIS v2.11"
Name "${SFX_Title}"
OutFile "${SFX_OutFile}"
InstallDir "${SFX_InstallDir}"
InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "InstallDirectory"


# -------------------------------------------------------------------
# Modern Interface Settings
# -------------------------------------------------------------------

!include "MUI.nsh"

!define MUI_ICON "Contrib\Graphics\Icons\${SFX_IconFile}-Install.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Contrib\Graphics\Wizard\${SFX_WizardImage}.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "Contrib\Graphics\Header\${SFX_HeaderImage}.bmp"
!define MUI_HEADERIMAGE_BITMAP_RTL "Contrib\Graphics\Header\${SFX_HeaderImage}-R.bmp"
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_LANGDLL_REGISTRY_ROOT "HKLM"
!define MUI_LANGDLL_REGISTRY_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "InstallLanguage"
!define MUI_LANGDLL_ALWAYSSHOW
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKLM"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "StartmenuFolder"
!define MUI_LICENSEPAGE_RADIOBUTTONS
!define MUI_UNICON "Contrib\Graphics\Icons\${SFX_IconFile}-Uninstall.ico"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Contrib\Graphics\Wizard\${SFX_WizardImage}.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_UNABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "C:\installation\gpl.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


# -------------------------------------------------------------------
# Multi-Language Support
# -------------------------------------------------------------------

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Spanish"


# -------------------------------------------------------------------
# Install Files Section
# -------------------------------------------------------------------

Section
  SetOutPath "$INSTDIR"
  File /r "C:\installation\UniversalReloader\UniversalReloader.exe"
  File /r "C:\installation\UniversalReloader\UniversalReloader.ini"
  File /r "C:\installation\UniversalReloader\GPL-3.0 fr.txt"
  File /r "C:\installation\UniversalReloader\GPL-3.0.fr.html"
  File /r "C:\installation\UniversalReloader\GPL-3.0.txt"

  SetOutPath "$DESKTOP"
  File /r "C:\installation\UniversalReloader\UniversalReloader.lnk"
  
SectionEnd


# -------------------------------------------------------------------
# Create Uninstaller Section
# -------------------------------------------------------------------

Section
  SetOutPath "$INSTDIR"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "DisplayName" "${SFX_Title}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "DisplayIcon" "$\"$INSTDIR\Uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "NoRepair" 1
SectionEnd


# -------------------------------------------------------------------
# Startmenu Section
# -------------------------------------------------------------------

Section
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\UniversalReloader.lnk" "$INSTDIR\UniversalReloader.exe"
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\$(^UninstallCaption).lnk" "$INSTDIR\Uninstall.exe"
  SetShellVarContext current

  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd



# -------------------------------------------------------------------
# Registry Section
# -------------------------------------------------------------------

Section
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "" "${SFX_Title}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}" "InstallDirectory" "$INSTDIR"
SectionEnd


# -------------------------------------------------------------------
# Initialization Functions
# -------------------------------------------------------------------

Function .onInit
  InitPluginsDir

  ClearErrors
  UserInfo::GetName
  IfErrors RunTheInstaller
  Pop $0
  UserInfo::GetAccountType
  Pop $1

  StrCmp $1 "Admin" RunTheInstaller
  StrCmp $1 "Power" RunTheInstaller
  MessageBox MB_OK|MB_ICONSTOP|MB_TOPMOST "The user $\"$0$\" is not allowed to install this application.$\nPlease ask your administrator's permission !!!"
  Quit

  RunTheInstaller:
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd



# -------------------------------------------------------------------
# Uninstaller Section
# -------------------------------------------------------------------

Section "Uninstall"
  RMDir /r "$INSTDIR"

  !insertmacro MUI_STARTMENU_GETFOLDER Application $R0
  SetShellVarContext all
  RMDir /r "$SMPROGRAMS\$R0"
  SetShellVarContext current

  SetShellVarContext all
  Delete "$DESKTOP\UniversalReloader.lnk"
  SetShellVarContext current

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SFX_AppID}"
SectionEnd


# -------------------------------------------------------------------
# Uninstaller Initialization Function
# -------------------------------------------------------------------

Function un.onInit
  InitPluginsDir

  ClearErrors
  UserInfo::GetName
  IfErrors RunTheUninstaller
  Pop $0
  UserInfo::GetAccountType
  Pop $1

  StrCmp $1 "Admin" RunTheUninstaller
  StrCmp $1 "Power" RunTheUninstaller
  MessageBox MB_OK|MB_ICONSTOP|MB_TOPMOST "The user $\"$0$\" is not allowed to uninstall this application.$\nPlease ask your administrator's permission !!!"
  Quit

  RunTheUninstaller:
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd



# ===================================================================
# End of File
# ===================================================================
