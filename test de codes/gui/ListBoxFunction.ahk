;
; AutoHotkey 		Version: 1.x
; Language:       	Français
; Platform:       	WinXP
; Author:         		IrisSoft 
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;
;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon
;
;
; ce programme essai de créer une fonction qui créer une zonne de liste
; si a l'exécution c'est refusé, nous passerons une donnerons une variable pour le nom de la zone de liste
; l'erreur viens de s'afficher a l'exécution, donc on vas essayer avec une variable 
; malheureusement même avec la variable liste ajouté a l'exécution la même variable s'affiche, donc abandon du projet pour l'instant. 
; on met dans la variable Choix les items de la liste déroulante
items = Premièr item de la liste || Deuxième item de la liste | Troisième item de la liste | Quatrième item de la liste | Cinqième item de la liste

; on met dans la variable liste le nom de la liste d'érounlante a savoir vChoix
liste = vChoix



Gosub, CreateListBox
Gui, Show,, Essai Liste 						      ;Affiche la zonne de liste avec le titre essailiste


;---------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------     Fonctions   ----------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------

; la fonction qui vas créer la zone de liste
CreateListBox:
	Gui, Add, ListBox, %liste% w500 h300 hscroll vscroll, %items%       ;crée une zone de liste
return

