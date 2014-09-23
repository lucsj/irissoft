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

Gui, 2:Add, Text, x20 y10 h40 w380, Pour jouer vous devez ajouter un jeton sur une `nde vos 6 rangés choisissez laquelle ?
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



;-------------------------------------------------------------------------------------------

; Racourcis clavier

;------------------------------------------------------------------------------------------------

#f4::
	Msgbox, le programme vas se fermer maintenant
	Gosub Exit
Return


;-----------------------------------------------------------------------------------------

; subs du jeu

;--------------------------------------------------------------------------------------

; affiche la fenêtre du menu principal

ShowMainWindows:
	Gui, 1:Show, w240 h170, Menu principal
Return

;---------------------------------------------------------------------------------------------------

; Affiche la fenêtre de jeu 

ShowPlayWindow:
	goplay = 0
	Gui, 2:Show, w400 h220, A vous de jouer Maintenant
Return

;-----------------------------------------------------------

; sub qui déclanche le jeu 

Play:
	Gui, 2:Submit
	goplay = 1
	if dr = 1
	{
		dr = 2
		jetons1 -=1
    	if Range = 1
	    {
    		a1 +=1
   			Msgbox %joueur%, a ajouté un jeton sur la rangé A, il lui reste %jetons1% jetons `n `n il y a %a1% jetons sur la rangée A
			if a1 = 10
   			{
   				Msgbox vous avez terminé la rangé A et gagnez 10 jettons
   				a1 = 0
   				jetons1 +=10
   			}
	    }
    	else if Range = 2
	    {
    		b1 +=1
   			Msgbox %joueur%, a ajouté un jeton sur la rangé B, il lui reste %jetons1% jetons `n `n il y a %b1% jetons sur la rangée B
	   		if b1 = 10
   			{
   				Msgbox vous avez terminé la rangé B et gagnez 10 jettons
   				b1 = 0
	   			jetons1 +=10
	   		}
	    }
    	else if Range = 3
	    {
	    	c1 +=1
	   		Msgbox %joueur%, a ajouté un jeton sur la rangé C, il lui reste %jetons1% jetons `n `n il y a %c1% jetons sur la rangée C
	   		if c1 = 10
   			{
   				Msgbox vous avez terminé la rangé C et gagnez 10 jettons
	   			c1 = 0
	   			jetons1 +=10
	   		}
	    }
	    else if Range = 4
	    {
	    	d1 +=1
	   		Msgbox %joueur% a ajouté un jeton sur la rangé D, il lui reste %jetons1% jetons `n `n il y a %d1% jetons sur la rangée D
	   		if d1 = 10
	   		{
	   			Msgbox vous avez terminé la rangé D
	   			d1 = 0
	   			jetons1 +=10
	   		}
    	}
	    else if Range = 5
    	{
	    	e1 +=1
	    	Msgbox %joueur%, a ajouté un jeton sur la rangé E, il lui reste %jetons1% jetons `n `n il y a %e1% jetons sur la rangée E
	   		if e1 = 10
	   		{
	   			Msgbox vous avez terminé la rangé E et gagnez 10 jettons
	   			e1 = 0
	   			jetons1 +=10
	   		}
	    }
	    else if Range = 6
	    {
	    	f1 +=1
	   		Msgbox %joueur%, a ajouté un jeton sur la rangé F, il lui reste %jetons1% jetons `n `n il y a %f1% jetons sur la rangée F
	   		if f1 = 10
	   		{
	   			Msgbox vous avez terminé la rangé F
	   			f1 = 0
	   			jetons1 +=10
	   		}
	    }
		joueur = %joueur2%
	}
	else if dr = 2
	{
		dr = 1
		jetons2 -=1
    	if Range = 1
	    {
    		a2 +=1
   			Msgbox %joueur%, a ajouté un jeton sur la rangé A, il lui reste %jetons2% jetons `n `n il y a %a2% jetons sur la rangée A
			if a2 = 10
   			{
   				Msgbox vous avez terminé la rangé A et gagnez 10 jettons
   				a2 = 0
   				jetons2 +=10
   			}
	    }
    	else if Range = 2
	    {
    		b2 +=1
   			Msgbox %joueur%, a ajouté un jeton sur la rangé B, il lui reste %jetons2% jetons `n `n il y a %b2% jetons sur la rangée B
	   		if b2 = 10
   			{
   				Msgbox vous avez terminé la rangé B et gagnez 10 jettons
   				b2 = 0
	   			jetons2 +=10
	   		}
	    }
    	else if Range = 3
	    {
	    	c2 +=1
	   		Msgbox %joueur%, a ajouté un jeton sur la rangé C, il lui reste %jetons2% jetons `n `n il y a %c2% jetons sur la rangée C
	   		if c2 = 10
   			{
   				Msgbox vous avez terminé la rangé C et gagnez 10 jettons
	   			c2 = 0
	   			jetons2 +=10
	   		}
	    }
	    else if Range = 4
	    {
	    	d2 +=1
	   		Msgbox %joueur% a ajouté un jeton sur la rangé D, il lui reste %jetons2% jetons `n `n il y a %d2% jetons sur la rangée D
	   		if d2 = 10
	   		{
	   			Msgbox vous avez terminé la rangé D
	   			d2 = 0
	   			jetons2 +=10
	   		}
    	}
	    else if Range = 5
    	{
	    	e2 +=1
	    	Msgbox %joueur%, a ajouté un jeton sur la rangé E, il lui reste %jetons2% jetons `n `n il y a %e2% jetons sur la rangée E
	   		if e2 = 10
	   		{
	   			Msgbox vous avez terminé la rangé E et gagnez 10 jettons
	   			e2 = 0
	   			jetons2 +=10
	   		}
	    }
	    else if Range = 6
	    {
	    	f2 +=1
	   		Msgbox %joueur%, a ajouté un jeton sur la rangé F, il lui reste %jetons2% jetons `n `n il y a %f2% jetons sur la rangée F
	   		if f2 = 10
	   		{
	   			Msgbox vous avez terminé la rangé F
	   			f2 = 0
	   			jetons2 +=10
	   		}
	    }
		joueur = %joueur1%
	}

Return




;exemple de sub pour lancer le jeu

Game:
	Gui, 1:Submit
	jetons1 = 50
	jetons2 = 50
    joueur1 = Luc
    Joueur2 = Jean
    a1=0
    b1=0
    c1=0
    d1=0
    e1=0
    f1=0
    a2=0
    b2=0
    c2=0
    d2=0
    e2=0
    f2=0
	goplay = 1
	dr = 1
	joueur = %joueur1%
	Loop,    
	{
		if jetons1 = 1
		{
			Msgbox Bravo %joueur2% vous avez gagné, et %joueur1% a perdu 
			Gosub ShowMainWindows	
			break				; on sort de la boucle			
		}
		if jetons2 = 1
		{
			Msgbox Bravo %joueur1% vous avez gagné, et %joueur2% a perdu 
			Gosub ShowMainWindows	
			break				; on sort de la boucle			
		}
		if goplay = 1 
		{
			GuiControl, 2:, TourJeu, C'est à %joueur% de jouer
			Gosub ShowPlayWindow
		}
		if goplay = 1 
		{
			GuiControl, 2:, TourJeu, C'est à %joueur% de jouer
			Gosub ShowPlayWindow
		}
	}
Return

;------------------------------------------------------------------------------------------

; quitter le programme

Exit:
   Gui cancel
   GuiEscape:
   ExitApp


