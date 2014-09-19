;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent  ; Keep the script running until the user exits it.

menu, tray, add,
Menu, test, add, A, MenuHandler
Menu, test, add, B, MenuHandler
Menu, test, add, C, MenuHandler
Menu, tray, add, Choice, :test

return

MenuHandler:

if (lastmenu <> A_ThisMenuItem)
 Menu %A_ThisMenu%, Uncheck, %lastmenu%
Menu %A_ThisMenu%, Check, %A_ThisMenuItem%
lastmenu := A_ThisMenuItem
return
