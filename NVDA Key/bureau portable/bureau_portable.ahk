Version = r25
NomDuScript =  Bureau Portable  %Version%


;----------------------------------------------------------------------------------------------------------------------------------------
; Nom :				Bureau Portable
; Language:       	Français
; Platform:         WinXP
; Auteurs:          Luc S, Michel Such
; AutoHotkey     	Version: 1.0.47
; Version :			Alpha rrelease 25
; Lissence :		GPL
; Description :		Lanceur des applications de la nvda key
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; petit encas textuel splash, qui indique le chargement du programme
SplashTextOn, , , Chargement en cours...


; lis les valeurs dans le fichier ini et les met dans des variables ou des tableaux
Gosub GetFromIniFile

; initialisation de l'applications vérifications de bases chargement de programme etc...
Gosub InitApp


; création du menu dans la zone de notiffication
Menu,Tray,Tip,%WinTitle%
Menu,Tray,NoStandard
Menu,Tray,Icon,Bureau_portable.ico
Menu,Tray,DeleteAll
Menu,Tray,Add,Réduire`t Ctrl+M,MinMax
Menu,Tray,Add,&A propos,HelpAbout
Menu,Tray,Add,

Gosub CreateProgMenu

Menu, tray, add, Programmes, :progs
Menu,Tray,Add,
Menu,Tray,Add,&Quitter`t Echap,GuiClose


   ;initialiser la fenêtre avec le texte et la liste
   Gui, Font, S13 CDefault, Arial							  ; Choix de la police d'affichage du logiciel et de sa taille
   Menu, FileMenu, add, &Quitter, GuiClose 
   Menu, OptionsMenu, add, &Options, Options
   Menu, OptionsMenu, add, Option des &programmes, ProgList
   Menu, HelpMenu, add, Aide, help
   Menu, HelpMenu, add, A &Propos, HelpAbout
   menu, MesMenus, add, &Fichiers, :FileMenu
   menu, MesMenus, add, &Options, :OptionsMenu
   menu, MesMenus, add, &Aide, :HelpMenu
   Gui, Menu, MesMenus
   Gui, Add, Text, x20 y4 w250 h20, Choisissez :
   Gui, Add, ListBox, vChoice gDbleClick x20 y30 w400 h300 vscroll AltSubmit, %items%
   Gui, Add, Button, vSend gValideMenu x50 y340 w100 h40 +Default, &Valider
   Gui, Add, Button, vCancel gQuitQuest x290 y340 w100 h40, &Quitter

   ;création de la fenêtre du sous-menu

   listitems =
   Gui, 2:Font, S13 CDefault, Arial							  ; Choix de la police d'affichage du logiciel et de sa taille
   Menu, FileMenu, add, &Quitter, GuiClose
   Menu, OptionsMenu, add, &Options, Options
   Menu, OptionsMenu, add, Option des &programmes, ProgList
   Menu, HelpMenu, add, Aide, help
   Menu, HelpMenu, add, A &Propos, HelpAbout
   menu, MesMenus, add, &Fichiers, :FileMenu
   menu, MesMenus, add, &Options, :OptionsMenu
   menu, MesMenus, add, &Aide, :HelpMenu
   Gui, 2:Menu, MesMenus
   Gui, 2:Add, Text, x20 y4 w250 h20, Choisissez une Application
   Gui, 2:Add, ListBox, vChoiceApp gDbleClick x20 y30 w400 h300 vscroll AltSubmit,
   Gui, 2:Add, Button, vSend gValide x50 y340 w100 h40 +Default, &Valider
   Gui, 2:Add, Button, vCancel gReturnMainMenu x290 y340 w100 h40, &Retour

; le chargement est finit on arrête le splash texte
SplashTextOff

	Gosub ShowMainWindow

return

; racourcis clavier de l'application

; le racourcit ctrl+M réduit ou agrandit la fenêtre du bureau portable dans la zone de notification
^m::
  Gosub MinMax    
return	

#IfWinActive ahk_class AutoHotkeyGUI		; Active les racourcis clavier uniquement si la fenêtre du programme est active
   ;la touche échap a pour effet de quitter imédiatement le programme
   Escape::
        Gosub GuiClose
   return

	; la touche backspace a pour effet de revenir au premier menu
	BS::
		Gui, 2:submit,   									 ; fait disparaitre la fenêtre
		Gosub ShowMainWindow							 ; affiche le menu principal
	return
#IfWinActive




;--------------------------------------------------------------------------------------------
; Fonctions qui lis les informations dans le fichier ini et stoque toutes les valeurs dans des variables


GetFromIniFile:
    
    ; Le fichier .ini doit avoir le même nom que le programme
    ; ce qui permet de copier le programme sous des noms différents
    ; avec des .ini différents
    SplitPath, A_ScriptName,,,, ScriptNoExt
    ScriptIni = %ScriptNoExt%.ini
    ; vérification de l'existance du fichier ini
    IfExist, %ScriptIni%
    {
        ; lis le nom du programme à lancé si il est spécifié
        IniRead Start, %ScriptIni%, Fenetre, Start, False
        IniRead StartAppName, %ScriptIni%, Fenetre, StartAppName, False  : lis le nom de l'application que le bureau portable à démarré
        IniRead Stop, %ScriptIni%, Fenetre, Stop, False      ; lis la commande pour arrêter l'application précédament démarreé par le bureau portable
		; teste si il y a plusieurs menus
		IniRead MenuName, %ScriptIni%, Menus, MenuName1, False				
		if MenuName = False							; si il n'y à pas plusieurs menus les variables sont remplit avec false,
		{
			Menus = 0
			TabCount = 1
			; lis le nom des programme et les met dans un tableau
			loop
			{
					IniRead AppName, %ScriptIni%, App%TabCount%, AppName, False 		;lit le nom du programme
					IniRead AppPath, %ScriptIni%, App%TabCount%, AppPath, False		;lis le chemin pour lancer le programme
					IniRead AppDir, %ScriptIni%, App%TabCount%, AppDir, False		;lit le répertoire de travail si précisé		        
					ProgNameItems%TabCount% := AppName        ; met le nom du programme dans un tableau
					ProgPathItems%TabCount% := AppPath        ; met le chemin de lancement du programme dans un tableau
					ProgDirItems%TabCount% := AppDir          ; met le dossier de travail du programme dans un tableau
					if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
					{
						break									; on sort de la boucle loop
					} 
					TabCount +=1
			}
			Gosub MakeAppList			; création de la liste des programmes sans menus
		}
		else
		{
			Menus = 1
			; initialisera le compteur qui servira à créer un tableau
			TabCount = 1
			; lis les noms des menus et les met dans un tableau
			Loop			; boucle sans fin se termine uniquement quand il n'y a plu de menus
			{
					IniRead MenuName, %ScriptIni%, Menus, MenuName%TabCount%, False
					MenuItems%TabCount% := MenuName 
					if MenuName = False						; si on arrive a la fin des menus les variables sont remplit avec false,
					{
							break			; On est arrivé a la fin de la liste des menus, donc on sort de la boucle
					}
					TabCount +=1
			}
			TabCount = 1
			; lis le nom des programme et leur menu correspondant et les met dans un tableau
			loop
			{
					IniRead AppName, %ScriptIni%, App%TabCount%, AppName, False 		;lit le nom du programme
					IniRead MenuNumber, %ScriptIni%, App%TabCount%, MenuNumber, False 	;lit le numéro du menu
					IniRead AppPath, %ScriptIni%, App%TabCount%, AppPath, False		;lis le chemin pour lancer le programme
					IniRead AppDir, %ScriptIni%, App%TabCount%, AppDir, False		;lit le répertoire de travail si précisé		        
					ProgNameItems%TabCount% := AppName        ; met le nom du programme dans un tableau
					MenuNumberItems%TabCount% := MenuNumber   ; met le numro du menu correspondant dans un tableau
					ProgPathItems%TabCount% := AppPath        ; met le chemin de lancement du programme dans un tableau
					ProgDirItems%TabCount% := AppDir          ; met le dossier de travail du programme dans un tableau
					if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
					{
						break									; on sort de la boucle loop
					} 
					TabCount +=1
			}
			Gosub CreateMenuList				; lance la fonction qui génère la liste des menus  
		}
	}
    else
    {
        MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter
        Gosub GuiClose     
    }

	
	
return

;-------------------------------------------------------------------------------------

; initialisation de l'aplication, charge les programme, fait quelques vérifications etc...

InitApp:

    ; lecture du titre de la fenêtre 
    IniRead WinTitle, %ScriptIni%, Fenetre, Titre, False 	;lit le titre de la fenêtre
    ; Vérifie si le titre n'a pas été défini et met celui par défaut
    if WinTitle = False ; Titre non défini
    {
	     WinTitle = %NomDuScript% - NVDA Key ; Titre par défaut
    }

    ; Classe de la fenêtre du bureau portable
    WinClass = ahk_class AutoHotkeyGUI

    ; indique si la fenêtre à été minimisé
    WinMin = 0

    ; Vérifie si un programme dois être démarré
    if Start <> False ; Lancer le programme
    {
	     Run, %Start%
    }


return

;------------------------------------------------------------------------------------

; fonction qui affiche la fenêtre principale du programme

ShowMainWindow:
  ; fenêtre du bureau portable (sert à minimiser)
  AppWin = %WinTitle% %WinClass%
	Gui, 1:Show, w440 h400, %Wintitle%
return

;----------------------------------------------------------------------------------------------

; affiche le sous-menu

ShowSubMenu:
	MenuTitle := MenuItems%Choice%                                          ; donne le nom du menu choisit
  ; fenêtre du bureau portable (sert à minimiser)
  AppWin = %MenuTitle% %WinClass%
	GuiControl, 2: , ChoiceApp, %listitems%
	Gui, 2:Show, w440 h400, %MenuTitle%
return

;-------------------------------------------------------------------------------------------------

; fonction qui permet d'utiliser le double click pour valider le choix d'un item des listes

DbleClick:
	IfNotEqual A_GuiControlEvent,DoubleClick 		; si c'est bien un doubleclick car un simple click active aussi la fonction
	{
		Return
	}
	else
	{
		if ( A_GuiControl="Choice")  ; si cela vient du menu principal
		{
			gosub ValideMenu
		}
		else ; sinon il sagit de lancer un programme
		{
			gosub Valide
		}
	}
return


;-----------------------------------------------------------------------------------------------------

; fonction qui lis la liste des menus dans un tableau

CreateMenuList:
	MenuCount = 1
	Loop			; boucle sans fin se termine uniquement quand il n'y a plu de menus
	{
    ; on vas chercher le nom du menu dans le tableau créé précédament
    MenuName := MenuItems%MenuCount%
    if MenuName = False						; si on arrive a la fin des menus les variables sont remplit avec false,
    {
        break			; On est arrivé a la fin de la liste des menus, donc on sort de la boucle
    }
		if MenuCount = 1							; si c'est la première fois qu'on ajoute un élément a  la liste
		{
      items = %MenuName%||					; ajouter le nom du menu qu'on atrouvé dans le fichier ini
		}
		else										; sinon dans tous les autres cas
		{
			items = %items%%MenuName%|				; on concatenne la liste avec les nouveaux éléments trouvés dans le fichier ini
		}
		MenuCount +=1								; on incrémente le compteur d'application
	}

return


;-------------------------------------------------------------------------------------------------------------

; défini et affecte la variable items, qui remplira la zonne de liste et dont les valeurs sont dans un tabbleau

MakeAppList:
	IniCount = 1									;Met a 1 le compteur des sections du fichier ini
	loop	; boucle sans fin se termine quand la valeur dans le tableau est fals ce qui signifie que c'est al fin du tableau
	{
		; on vas chercher les valeur dans les tableaux créer précédament 
		AppName := ProgNameItems%IniCount%        ; vas chercher le nom du programme dans le tableau et l'affecte à une variable

		if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
		{
			break									; on sort de la boucle loop
		}
		if IniCount = 1								; si c'est la première fois qu'on ajoute un élément a  la liste
		{
			listitems = |%AppName% ||             ; ajouter le nom de l'application qu'on atrouvé dans le fichier ini
			AppNumber%MenuCount% := IniCount      ; enregistrer le numéro de l'aplication dans un tableau
		}
		else										; sinon dans tous les autres cas
		{
			listitems = %listitems%%AppName%|	; on concatenne la liste avec les nouveaux éléments trouvés dans le fichier ini
			AppNumber%MenuCount% := IniCount      ; enregistrer le numéro de l'aplication dans un tableau
		}
		IniCount +=1								; on incrémente le compteur d'application
	}
return

;-----------------------------------------------------------------------------------------------
; Met dans la liste les applications qui correspondent au menu choisit

CreateAppsMenu:
	IniCount = 1									;Met a 1 le compteur des sections du fichier ini
	MenuCount = 1									; met a un le compteur d'items du menu

	loop	; boucle sans fin se termine quand la valeur dans le tableau est fals ce qui signifie que c'est al fin du tableau
	{
		; on vas chercher les valeur dans les tableaux créer précédament 
		AppName := ProgNameItems%IniCount%        ; vas chercher le nom du programme dans le tableau et l'affecte à une variable
		MenuNumber := MenuNumberItems%IniCount%   ; vas chercher le numéro du menu correspondant dans le tableau et l'affecte a une variable

		if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
		{
			break									; on sort de la boucle loop
		}

		if MenuNumber = %Choice%							; si le numéro du menu correspond au choix
		{
			if MenuCount = 1								; si c'est la première fois qu'on ajoute un élément a  la liste
			{
				listitems = |%AppName% || 					; ajouter le nom de l'application qu'on atrouvé dans le fichier ini
				AppNumber%MenuCount% := IniCount      ; enregistrer le numéro de l'aplication dans un tableau
			}
			else										; sinon dans tous les autres cas
			{
				listitems = %listitems%%AppName%|	; on concatenne la liste avec les nouveaux éléments trouvés dans le fichier ini
				AppNumber%MenuCount% := IniCount      ; enregistrer le numéro de l'aplication dans un tableau
			}
			MenuCount += 1
		}
		IniCount +=1								; on incrémente le compteur d'application
	}
return


;-----------------------------------------------------------------------------------------------
; sub qui est lancé quand on clique sur le bouton Retour

ReturnMainMenu:
	Gui, 2:submit,   									 ; fait disparaitre la fenêtre
	Gosub ShowMainWindow							 ; affiche le menu principal
return


;------------------------------------------------------------------------------
; cette fonction est lancé quand on valide sur la liste, elle renvoie le choix dans la variable Choice et l'exécute


Valide:
	Gui, 2:Submit,NoHide
	GuiControlGet, ChoiceApp                             		; Renvoie le choix fait par l'utilisateur
	number := AppNumber%ChoiceApp%                          ; met dans la variable number le numéro correspondant à l'applicatioh choisit
	AppPath := ProgPathItems%number%                       ; lis le chemin pour lancer le programme dans un tableau
	AppDir := ProgDirItems%number%                         ; lis le dossier de travail du programme dans un tableau
	; teste si le dossier de travail est spéciffié
	if AppDir = False
	{
		Run, %AppPath%															; exécute le programme choisit par l'utilisateur
	}
	else
	{
		Run, %AppPath%, %Appdir%												; exécute le programme choisit par l'utilisateur
	}
return
;----------------------------------------------------------------------------------------------------------------------------------------

;  sub qui valide la liste des menus ou des programmes quand il n'y a pas de menus
ValideMenu:
	if Menus = 1
	{
		Gui, 1:submit,   									 ; fait disparaitre la fenêtre
		GuiControlGet, Choice                             ; Renvoie le choix fait par l'utilisateur
		llistitems = ""
		Gosub CreateAppsMenu				  ; raffraichit la liste avec les nouvelles valeurs
		Gosub ShowSubMenu								  ; raffiche le sous-menu
	}
	else
	{
		Gui, 1:Submit,NoHide
		GuiControlGet, Choice                             				; Renvoie le choix fait par l'utilisateur
		number := AppNumber%Choice%                 ; met dans la variable number le numéro correspondant à l'applicatioh choisit
		AppPath := ProgPathItems%number%            ; lis le chemin pour lancer le programme dans un tableau
		AppDir := ProgDirItems%number%              ; lis le dossier de travail du programme dans un tableau
		if AppDir = False
		{
			Run, %AppPath%															; exécute le programme choisit par l'utilisateur
		}
		else
		{
			Run, %AppPath%, %Appdir%												; exécute le programme choisit par l'utilisateur
		}
	}
return

;-------------------------------------------------------------------------------------------------------------------------------------


Options:

return

;------------------------------------------------------------------------------

ProgList:

return


;---------------------------------------------------------------

Help:

return

;---------------------------------------------------------------------------
; créé un sous menu du menu de la zone de notification qui contiendra tous les programmes

CreateProgMenu:

	IniCount = 1									;Met a 1 le compteur des sections du tableau
	loop	; boucle sans fin se termine quand la valeur dans le tableau est fals ce qui signifie que c'est la fin du tableau
	{
		; on vas chercher les valeur dans le tableaux créer précédament 
		AppName := ProgNameItems%IniCount%        ; vas chercher le nom du programme dans le tableau et l'affecte à une variable
		if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
		{
			break									; on sort de la boucle loop
		}
		menu, progs, add, %AppName%, RunMenuApp
		IniCount +=1								; on incrémente le compteur d'application
	}

return


;-------------------------------------------------------------------
; Exécute les applications à partir du menu de la zone de notification

RunMenuApp:
	AppPath := ProgPathItems%A_ThisMenuItemPos%
	Run, %AppPath%
return



;----------------------------------------------------------------------
; affiche une msgbox avec un texte a propos du logiciel

HelpAbout:
	MsgBox, %NomDuScript% `n `nCe programme à été créé par  : `n `n `t - Luc SEGURA `n `t - Michel SUCH `n `t - Jeannot40 `n `n lissence : GPL `n
return


;----------------------------------------------------------------------------------

; minimise ou maximise la fenêtre du bureau portable

MinMax:
  if WinMin = 0
  {
      Menu, Tray, Rename, Réduire`t Ctrl+M, Agrandir`t Ctrl+M
      WinHide, %AppWin%
      WinMin = 1  
  }
  else
  {
      Menu, Tray, Rename, Agrandir`t Ctrl+M, Réduire`t Ctrl+M
      WinShow, %AppWin%
      WinActivate, %AppWin%
      WinMin = 0
  }

return

;-----------------------------------------------------------------

; sub qui vérifie si un programme à été lancé et demande si il doit être arrêté

QuitQuest:
   if Stop <> false
   {   
        MsgBox, 4, , Voulez-vous quitter %StartAppName% ?
        IfMsgBox, Yes
        {
            if Stop <> False ; si le fichier ini spécifie qu'il faut arrêté le programme qui à été démaré
            {
   	            Run, %Stop%        ; exécuter la commande spéciffié dans la variable stop contenant la commande pour stoper le programme
            } 
        }
   }
Return
;---------------------------------------------------------------------

;Ferme le programme

GuiClose:
   Gosub QuitQuest
   Gui cancel
   GuiEscape:
   ExitApp







