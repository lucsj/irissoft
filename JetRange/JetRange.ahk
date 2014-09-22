#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;création de la fenêtre principale contenant deux boutons

; Créer le GUI principal avec une marge
Gui, 1:Margin, 5, 5

; Choix de la police d'affichage du logiciel et de sa taille
Gui, 1:Font, S12 CDefault, Arial

; création du menu principale du jeu :
Gui, 1:Add, GroupBox, x10 y20 w210 h130, Menu principal
Gui, 1:Add, Button, gGame x40 y45 w140 h40, &Jouer
Gui, 1:Add, Button, gExit x40 y100 w140 h40, &Quitter

;fenêtre principale du jeu

; Créer le GUI principal avec une marge
Gui, 2:Margin, 5, 5

; Choix de la police d'affichage du logiciel et de sa taille
Gui, 2:Font, S12 CDefault, Arial

Gui, 2:Add, Text, x20 y10 h20 w380, Pour jouer vous devez ajouter un jeton dans une de vos 6 rangés choisissez laquelle ?
Gui, 2:Add, GroupBox, vTourJeu x20 y70 h70 w340, C'est à %joueur% de jouer
Gui, 2:Add, Radio, vRange x30 y90 w40 h40, A  
Gui, 2:Add, Radio, x80 y90 w40 h40, B  
Gui, 2:Add, Radio, x130 y90 w40 h40, C
Gui, 2:Add, Radio, x180 y90 w40 h40, D
Gui, 2:Add, Radio, x230 y90 w40 h40, E
Gui, 2:Add, Radio, x280 y90 w40 h40, F
gui, 2:Add, Button, gPlay x160 y155 w60 h40 +Default, &Jouer


; Lance la sub qui affiche la fenêtre principale du programme
Gosub ShowMainWindows


Return



;-----------------------------------------------------------------------------------------

; subs du jeu

;--------------------------------------------------------------------------------------

ShowMainWindows:

	Gui, 1:Show, w240 h170, Menu principal

Return

;---------------------------------------------------------------------------------------------------

; Affiche la fenêtre de jeu 

ShowPlayWindow:
	Gui, 2:Show, w400 h220, A vous de jouer Maintenant
Return

;-----------------------------------------------------------

; sub qui déclanche le jeu 

Play:
	Gui, 2:Submit
	jetons -=1
    if Range = 1
    {
    	A +=1
   		Msgbox %joueur%, a ajouté un jeton sur la rangé A, il lui reste %jetons% jetons `n `n il y a %A% jetons sur la rangée A
   		if a = 10
   		{
   			Msgbox vous avez terminé la rangé A
   			a = 0
   			jetons +=10
   		}
    }
    else if Range = 2
    {
    	B +=1
   		Msgbox %joueur%, a ajouté un jeton sur la rangé B, il lui reste %jetons% jetons `n `n il y a %B% jetons sur la rangée B
   		if b = 10
   		{
   			Msgbox vous avez terminé la rangé B
   			b = 0
   			jetons +=10
   		}
    }
    else if Range = 3
    {
    	C +=1
   		Msgbox %joueur%, a ajouté un jeton sur la rangé C, il lui reste %jetons% jetons `n `n il y a %C% jetons sur la rangée C
   		if c = 10
   		{
   			Msgbox vous avez terminé la rangé C
   			c = 0
   			jetons +=10
   		}
    }
    else if Range = 4
    {
    	D +=1
   		Msgbox %joueur% a ajouté un jeton sur la rangé D, il lui reste %jetons% jetons `n `n il y a %D% jetons sur la rangée D
   		if d = 10
   		{
   			Msgbox vous avez terminé la rangé D
   			d = 0
   			jetons +=10
   		}
    }
    else if Range = 5
    {
    	E +=1
    	Msgbox %joueur%, a ajouté un jeton sur la rangé E, il lui reste %jetons% jetons `n `n il y a %E% jetons sur la rangée E
   		if e = 10
   		{
   			Msgbox vous avez terminé la rangé E
   			e = 0
   			jetons +=10
   		}
    }
    else if Range = 6
    {
    	F +=1
   		Msgbox %joueur%, a ajouté un jeton sur la rangé F, il lui reste %jetons% jetons `n `n il y a %F% jetons sur la rangée F
   		if a = 10
   		{
   			Msgbox vous avez terminé la rangé F
   			f = 0
   			jetons +=10
   		}
    }
	Gosub ShowMainWindows	
Return




;exemple de sub pour lancer le jeu

Game:
	Gui, 1:Submit
	jetons = 50
    joueur = Luc
    a=0
    b=0
    c=0
    d=0
    e=0
    f=0
    GuiControl, 2:, TourJeu, C'est à %joueur% de jouer
	Loop,    
	{
		if jetons = 10
		{
			Msgbox Le jeu est terminé
			break				; on sort de la boucle			
		}
		Gosub ShowPlayWindow
	}
Return

;------------------------------------------------------------------------------------------

; quitter le programme

Exit:
   Gui cancel
   GuiEscape:
   ExitApp


