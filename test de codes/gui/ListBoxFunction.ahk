;
; AutoHotkey 		Version: 1.x
; Language:       	Fran�ais
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
; ce programme essai de cr�er une fonction qui cr�er une zonne de liste
; si a l'ex�cution c'est refus�, nous passerons une donnerons une variable pour le nom de la zone de liste
; l'erreur viens de s'afficher a l'ex�cution, donc on vas essayer avec une variable 
; malheureusement m�me avec la variable liste ajout� a l'ex�cution la m�me variable s'affiche, donc abandon du projet pour l'instant. 
; on met dans la variable Choix les items de la liste d�roulante
items = Premi�r item de la liste || Deuxi�me item de la liste | Troisi�me item de la liste | Quatri�me item de la liste | Cinqi�me item de la liste

; on met dans la variable liste le nom de la liste d'�rounlante a savoir vChoix
liste = vChoix



Gosub, CreateListBox
Gui, Show,, Essai Liste 						      ;Affiche la zonne de liste avec le titre essailiste


;---------------------------------------------------------------------------------------------------------------------------------------
;---------------------------------------------------     Fonctions   ----------------------------------------------------------------
;---------------------------------------------------------------------------------------------------------------------------------------

; la fonction qui vas cr�er la zone de liste
CreateListBox:
	Gui, Add, ListBox, %liste% w500 h300 hscroll vscroll, %items%       ;cr�e une zone de liste
return

