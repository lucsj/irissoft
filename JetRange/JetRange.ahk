#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;création de la fenêtre principale contenant deux boutons

; Créer le GUI principal avec une marge
Gui, 1:Margin, 5, 5

; Choix de la police d'affichage du logiciel et de sa taille
Gui, 1:Font, S12 CDefault, Arial

; création de la fenêtre principale du jeu :
Gui, 1:Add, GroupBox, x10 y20 w210 h130, Menu principal
Gui, 1:Add, Button, gGame x40 y45 w140 h40, Jouer
Gui, 1:Add, Button, gExit x40 y100 w140 h40, Quitter
 









;-----------------------------------------------------------------------------------------

; subs du jeu

;--------------------------------------------------------------------------------------

ShowMainWindows:

	Gui, 1:Show, w240 h170, Menu principal

Return




;-----------------------------------------------------------

;exemple de sub pour lancer le jeu

Game:

	jetons = 50
	Msgbox, voici le nombre de jetons : %jetons%
	jetons +=30
	MsgBox, et m'intenant j'ai gagné j'en ait combien ? %jetons%

Return

;------------------------------------------------------------------------------------------

; quitter le programme

Exit:
   Gui cancel
   GuiEscape:
   ExitApp


