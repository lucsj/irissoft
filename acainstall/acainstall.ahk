#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon   ; pas d'icône dans la zone de notification

; Créer le GUI principal avec une marge
Gui, Margin, 5, 5

; Choix de la police d'affichage du logiciel et de sa taille
Gui, Font, S12 CDefault, Arial

Gui, Add, Text, x30 y40 w150 h40, Installation d'acapella4 :
Gui, Show, w300 h70, acainstaller 1.0

Run, infovox4demo.exe, C:\Acapela4, hide
Sleep, 3000
RunWait, Reg.bat, C:\Acapela4, hide
Sleep, 3000
RunWait, infovox4.exe, C:\Acapela4, hide
Sleep, 3000
MsgBox, 4, , Voulez-vous installer l'extenssion pour nvda ? (attention nvda doit être lancé)
IfMsgBox, No									; si le choix est non, on sort de la fonction
{
	return
}
else										    ; si l'utilisateur a répondu oui 
{
	RunWait, Acapela Infovox4-driver.nvda-addon, C:\Acapela4, hide
}
Sleep, 3000

Gui, cancel
GuiEscape:
ExitApp
