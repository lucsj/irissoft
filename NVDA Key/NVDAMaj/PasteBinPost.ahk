;PasteBinPost.ahk
; Press Win+S to post your clipboard contents to PasteBin.com and return the URL
;Intallation:
; Save the script as PasteBinPost.ahk 
; Download and install AutoHotkey from www.autohotkey.com
; Download WGet.exe from http://users.ugent.be/~bpuype/wget/#download
;Skrommel @2006

FileInstall,wget.exe,wget.exe
#SingleInstance,Force
#NoEnv
SetBatchLines,-1
SetFormat,Integer,Hex

applicationname=PasteBinPost
Gosub,INIREAD
Gosub,TRAYMENU

Hotkey,%post%,POST

If startdisabled=1
  Gosub,SWAP
Return


POST:
TrayTip,PasteBinPost,Posting to PasteBin.com...
in:=Clipboard
out=
Loop,Parse,in
{
  Transform,char,Asc,%A_LoopField%
  StringRight,char,char,2
  out=%out%`%%char%
}
StringReplace,out,out,x,0,All

time:=A_Now
StringReplace,runcommand,command,<time>,%time%
StringReplace,runcommand,runcommand,<out>,%out%

RunWait,%runcommand%
Loop,%time%\*.*
  file:=A_LoopFileName
Gui,Add,Edit,w300,http://pastebin.com/%file%
Gui,Add,Button,w75 GCOPY,&Copy
Gui,Add,Button,x+5 w75 GVISIT,&Visit
Gui,Show,,PasteBinPost - 1 Hour Software
TrayTip,
Return

COPY:
Gui,Submit
Clipboard=http://pastebin.com/%file%
Gosub,GuiClose
Return

VISIT:
Gui,Submit
Clipboard=http://pastebin.com/%file%
Run,%Clipboard%
Gosub,GuiClose
Return

GuiClose:
Gui,Destroy
FileRemoveDir,%time%,1
Return

;Function Hexify by Laszlo 
Hexify(x)                     ; Convert a string to a huge hex number starting with X 
{ 
   StringLen Len, x 
   format = %A_FormatInteger% 
   SetFormat Integer, H 
   hex = X 
   Loop %Len% 
   { 
      Transform y, ASC, %x%   ; ASCII code of 1st char, 15 < y < 256 
      StringTrimLeft y, y, 2  ; Remove leading 0x 
      hex = %hex%%y% 
      StringTrimLeft x, x, 1  ; Remove 1st char 
   } 
   SetFormat Integer, %format% 
   Return hex 
}

TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,%applicationname%,SWAP
Menu,Tray,Add,
Menu,Tray,Add,&Enabled,SWAP
Menu,Tray,Add,
Menu,Tray,Add,&Settings...,SETTINGS
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,E&xit,EXIT
Menu,Tray,Check,&Enabled
Menu,Tray,Default,%applicationname%
Menu,Tray,Tip,%applicationname%
Return

SWAP:
Menu,Tray,ToggleCheck,&Enabled
Suspend,Toggle
Return


INIREAD:
IfNotExist,%applicationname%.ini
{
  activemonitor=1
  startdisabled=0
  post=#s
  command=WGET.exe --directory-prefix=<time>/ --post-data 'parent_pid=&format=text&code2=<out>&poster=&paste=Send' http://pastebin.com/
  Gosub,INIWRITE
}
IniRead,command,%applicationname%.ini,Settings,command
IniRead,startdisabled,%applicationname%.ini,Settings,startdisabled
IniRead,post,%applicationname%.ini,Settings,post
Return

INIWRITE:
IniWrite,%command%,%applicationname%.ini,Settings,command
IniWrite,%startdisabled%,%applicationname%.ini,Settings,startdisabled
IniWrite,%post%,%applicationname%.ini,Settings,post
Return

SETTINGS:
HotKey,%post%,Off
Gui,Destroy
Gui,Add,GroupBox,xm ym w320 h100,Post &Command
Gui,Add,Edit,xm+10 yp+20 w300 r4 Vvcommand,%command%

Gui,Add,GroupBox,xm y+30 w320 h50,Startup
Gui,Add,Checkbox,xp+10 yp+20 Checked%startdisabled% Vvstartdisabled,&Start disabled

Gui,Add,GroupBox,xm y+30 w320 h70,&Hotkey
Gui,Add,Hotkey,xp+10 yp+20 w200 vvpost
StringReplace,current,post,+,Shift +%A_Space%
StringReplace,current,current,^,Ctrl +%A_Space%
StringReplace,current,current,!,Alt +%A_Space%
StringReplace,current,current,#,Win +%A_Space%
Gui,Add,Text,xm+20 y+5,Current hotkey: %current%

Gui,Add,Button,xm y+20 w75 Default GSETTINGSOK,&OK
Gui,Add,Button,x+5 w75 GSETTINGSCANCEL,&Cancel
Gui,Show,,%applicationname% Settings
Return

SETTINGSOK:
Gui,Submit
startdisabled:=vstartdisabled
If vpost<>
{
  post:=vpost
  HotKey,%post%,POST
  HotKey,%post%,On
}
If vcommand<>
  command:=vcommand
Gosub,INIWRITE
SysGet,monitor,Monitor,%activemonitor%
Return

SETTINGSCANCEL:
HotKey,%post%,POST
HotKey,%post%,On
Gui,Destroy
Return


ABOUT:
Gui,Destroy
Gui,Add,Text,y-5,`t
Gui,Add,Picture,Icon1,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,%applicationname% v1.0
Gui,Font
Gui,Add,Text,xm,Post you clipboard contents to PasteBin.com and return the URL 
Gui,Add,Text,xm,- Press Win+S to post. 
Gui,Add,Text,xm,- Change the settings using Settings in the tray menu.
Gui,Add,Text,y+0,`t
Gui,Add,Picture,Icon2,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,1 Hour Software by Skrommel
Gui,Font
Gui,Add,Text,xm,For more tools and information, please stop by at
Gui,Font,CBlue Underline
Gui,Add,Text,xm GWWW,http://www.donationcoders.com/skrommel
Gui,Font
Gui,Add,Text,y+0,`t
Gui,Add,Picture,Icon6,%applicationname%.exe
Gui,Font,Bold
Gui,Add,Text,x+10 yp+10,AutoHotkey
Gui,Font
Gui,Add,Text,xm,This program is made using AutoHotkey
Gui,Font,CBlue Underline
Gui,Add,Text,xm GAUTOHOTKEY,http://www.autohotkey.com
Gui,Font
Gui,Add,Text,y+0,`t
Gui,Add,Button,GABOUTOK Default w75,&OK
Gui,Show,,%applicationname% About

hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

AUTOHOTKEY:
Run,http://www.autohotkey.com,,UseErrorLevel
Return

WWW:
Run,http://www.donationcoders.com/skrommel,,UseErrorLevel
Return

ABOUTOK:
Gui,Destroy
OnMessage(0x200,"") 
DllCall("DestroyCursor","Uint",hCur) 
Return

EXIT:
ExitApp


WM_MOUSEMOVE(wParam,lParam)
{
  Global hCurs
  MouseGetPos,,,,ctrl
  If ctrl in Static11,Static16
    DllCall("SetCursor","UInt",hCurs)
  Return
}