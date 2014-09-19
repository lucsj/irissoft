Version = r25
NomDuScript =  Bureau Portable  %Version%


;----------------------------------------------------------------------------------------------------------------------------------------
; Nom :				Bureau Portable
; Language:       	Fran�ais
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

; initialisation de l'applications v�rifications de bases chargement de programme etc...
Gosub InitApp


; cr�ation du menu dans la zone de notiffication
Menu,Tray,Tip,%WinTitle%
Menu,Tray,NoStandard
Menu,Tray,Icon,Bureau_portable.ico
Menu,Tray,DeleteAll
Menu,Tray,Add,R�duire`t Ctrl+M,MinMax
Menu,Tray,Add,&A propos,HelpAbout
Menu,Tray,Add,

Gosub CreateProgMenu

Menu, tray, add, Programmes, :progs
Menu,Tray,Add,
Menu,Tray,Add,&Quitter`t Echap,GuiClose


   ;initialiser la fen�tre avec le texte et la liste
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

   ;cr�ation de la fen�tre du sous-menu

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

; le chargement est finit on arr�te le splash texte
SplashTextOff

	Gosub ShowMainWindow

return

; racourcis clavier de l'application

; le racourcit ctrl+M r�duit ou agrandit la fen�tre du bureau portable dans la zone de notification
^m::
  Gosub MinMax    
return	

#IfWinActive ahk_class AutoHotkeyGUI		; Active les racourcis clavier uniquement si la fen�tre du programme est active
   ;la touche �chap a pour effet de quitter im�diatement le programme
   Escape::
        Gosub GuiClose
   return

	; la touche backspace a pour effet de revenir au premier menu
	BS::
		Gui, 2:submit,   									 ; fait disparaitre la fen�tre
		Gosub ShowMainWindow							 ; affiche le menu principal
	return
#IfWinActive




;--------------------------------------------------------------------------------------------
; Fonctions qui lis les informations dans le fichier ini et stoque toutes les valeurs dans des variables


GetFromIniFile:
    
    ; Le fichier .ini doit avoir le m�me nom que le programme
    ; ce qui permet de copier le programme sous des noms diff�rents
    ; avec des .ini diff�rents
    SplitPath, A_ScriptName,,,, ScriptNoExt
    ScriptIni = %ScriptNoExt%.ini
    ; v�rification de l'existance du fichier ini
    IfExist, %ScriptIni%
    {
        ; lis le nom du programme � lanc� si il est sp�cifi�
        IniRead Start, %ScriptIni%, Fenetre, Start, False
        IniRead StartAppName, %ScriptIni%, Fenetre, StartAppName, False  : lis le nom de l'application que le bureau portable � d�marr�
        IniRead Stop, %ScriptIni%, Fenetre, Stop, False      ; lis la commande pour arr�ter l'application pr�c�dament d�marre� par le bureau portable
		; teste si il y a plusieurs menus
		IniRead MenuName, %ScriptIni%, Menus, MenuName1, False				
		if MenuName = False							; si il n'y � pas plusieurs menus les variables sont remplit avec false,
		{
			Menus = 0
			TabCount = 1
			; lis le nom des programme et les met dans un tableau
			loop
			{
					IniRead AppName, %ScriptIni%, App%TabCount%, AppName, False 		;lit le nom du programme
					IniRead AppPath, %ScriptIni%, App%TabCount%, AppPath, False		;lis le chemin pour lancer le programme
					IniRead AppDir, %ScriptIni%, App%TabCount%, AppDir, False		;lit le r�pertoire de travail si pr�cis�		        
					ProgNameItems%TabCount% := AppName        ; met le nom du programme dans un tableau
					ProgPathItems%TabCount% := AppPath        ; met le chemin de lancement du programme dans un tableau
					ProgDirItems%TabCount% := AppDir          ; met le dossier de travail du programme dans un tableau
					if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
					{
						break									; on sort de la boucle loop
					} 
					TabCount +=1
			}
			Gosub MakeAppList			; cr�ation de la liste des programmes sans menus
		}
		else
		{
			Menus = 1
			; initialisera le compteur qui servira � cr�er un tableau
			TabCount = 1
			; lis les noms des menus et les met dans un tableau
			Loop			; boucle sans fin se termine uniquement quand il n'y a plu de menus
			{
					IniRead MenuName, %ScriptIni%, Menus, MenuName%TabCount%, False
					MenuItems%TabCount% := MenuName 
					if MenuName = False						; si on arrive a la fin des menus les variables sont remplit avec false,
					{
							break			; On est arriv� a la fin de la liste des menus, donc on sort de la boucle
					}
					TabCount +=1
			}
			TabCount = 1
			; lis le nom des programme et leur menu correspondant et les met dans un tableau
			loop
			{
					IniRead AppName, %ScriptIni%, App%TabCount%, AppName, False 		;lit le nom du programme
					IniRead MenuNumber, %ScriptIni%, App%TabCount%, MenuNumber, False 	;lit le num�ro du menu
					IniRead AppPath, %ScriptIni%, App%TabCount%, AppPath, False		;lis le chemin pour lancer le programme
					IniRead AppDir, %ScriptIni%, App%TabCount%, AppDir, False		;lit le r�pertoire de travail si pr�cis�		        
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
			Gosub CreateMenuList				; lance la fonction qui g�n�re la liste des menus  
		}
	}
    else
    {
        MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arr�ter
        Gosub GuiClose     
    }

	
	
return

;-------------------------------------------------------------------------------------

; initialisation de l'aplication, charge les programme, fait quelques v�rifications etc...

InitApp:

    ; lecture du titre de la fen�tre 
    IniRead WinTitle, %ScriptIni%, Fenetre, Titre, False 	;lit le titre de la fen�tre
    ; V�rifie si le titre n'a pas �t� d�fini et met celui par d�faut
    if WinTitle = False ; Titre non d�fini
    {
	     WinTitle = %NomDuScript% - NVDA Key ; Titre par d�faut
    }

    ; Classe de la fen�tre du bureau portable
    WinClass = ahk_class AutoHotkeyGUI

    ; indique si la fen�tre � �t� minimis�
    WinMin = 0

    ; V�rifie si un programme dois �tre d�marr�
    if Start <> False ; Lancer le programme
    {
	     Run, %Start%
    }


return

;------------------------------------------------------------------------------------

; fonction qui affiche la fen�tre principale du programme

ShowMainWindow:
  ; fen�tre du bureau portable (sert � minimiser)
  AppWin = %WinTitle% %WinClass%
	Gui, 1:Show, w440 h400, %Wintitle%
return

;----------------------------------------------------------------------------------------------

; affiche le sous-menu

ShowSubMenu:
	MenuTitle := MenuItems%Choice%                                          ; donne le nom du menu choisit
  ; fen�tre du bureau portable (sert � minimiser)
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
    ; on vas chercher le nom du menu dans le tableau cr�� pr�c�dament
    MenuName := MenuItems%MenuCount%
    if MenuName = False						; si on arrive a la fin des menus les variables sont remplit avec false,
    {
        break			; On est arriv� a la fin de la liste des menus, donc on sort de la boucle
    }
		if MenuCount = 1							; si c'est la premi�re fois qu'on ajoute un �l�ment a  la liste
		{
      items = %MenuName%||					; ajouter le nom du menu qu'on atrouv� dans le fichier ini
		}
		else										; sinon dans tous les autres cas
		{
			items = %items%%MenuName%|				; on concatenne la liste avec les nouveaux �l�ments trouv�s dans le fichier ini
		}
		MenuCount +=1								; on incr�mente le compteur d'application
	}

return


;-------------------------------------------------------------------------------------------------------------

; d�fini et affecte la variable items, qui remplira la zonne de liste et dont les valeurs sont dans un tabbleau

MakeAppList:
	IniCount = 1									;Met a 1 le compteur des sections du fichier ini
	loop	; boucle sans fin se termine quand la valeur dans le tableau est fals ce qui signifie que c'est al fin du tableau
	{
		; on vas chercher les valeur dans les tableaux cr�er pr�c�dament 
		AppName := ProgNameItems%IniCount%        ; vas chercher le nom du programme dans le tableau et l'affecte � une variable

		if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
		{
			break									; on sort de la boucle loop
		}
		if IniCount = 1								; si c'est la premi�re fois qu'on ajoute un �l�ment a  la liste
		{
			listitems = |%AppName% ||             ; ajouter le nom de l'application qu'on atrouv� dans le fichier ini
			AppNumber%MenuCount% := IniCount      ; enregistrer le num�ro de l'aplication dans un tableau
		}
		else										; sinon dans tous les autres cas
		{
			listitems = %listitems%%AppName%|	; on concatenne la liste avec les nouveaux �l�ments trouv�s dans le fichier ini
			AppNumber%MenuCount% := IniCount      ; enregistrer le num�ro de l'aplication dans un tableau
		}
		IniCount +=1								; on incr�mente le compteur d'application
	}
return

;-----------------------------------------------------------------------------------------------
; Met dans la liste les applications qui correspondent au menu choisit

CreateAppsMenu:
	IniCount = 1									;Met a 1 le compteur des sections du fichier ini
	MenuCount = 1									; met a un le compteur d'items du menu

	loop	; boucle sans fin se termine quand la valeur dans le tableau est fals ce qui signifie que c'est al fin du tableau
	{
		; on vas chercher les valeur dans les tableaux cr�er pr�c�dament 
		AppName := ProgNameItems%IniCount%        ; vas chercher le nom du programme dans le tableau et l'affecte � une variable
		MenuNumber := MenuNumberItems%IniCount%   ; vas chercher le num�ro du menu correspondant dans le tableau et l'affecte a une variable

		if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
		{
			break									; on sort de la boucle loop
		}

		if MenuNumber = %Choice%							; si le num�ro du menu correspond au choix
		{
			if MenuCount = 1								; si c'est la premi�re fois qu'on ajoute un �l�ment a  la liste
			{
				listitems = |%AppName% || 					; ajouter le nom de l'application qu'on atrouv� dans le fichier ini
				AppNumber%MenuCount% := IniCount      ; enregistrer le num�ro de l'aplication dans un tableau
			}
			else										; sinon dans tous les autres cas
			{
				listitems = %listitems%%AppName%|	; on concatenne la liste avec les nouveaux �l�ments trouv�s dans le fichier ini
				AppNumber%MenuCount% := IniCount      ; enregistrer le num�ro de l'aplication dans un tableau
			}
			MenuCount += 1
		}
		IniCount +=1								; on incr�mente le compteur d'application
	}
return


;-----------------------------------------------------------------------------------------------
; sub qui est lanc� quand on clique sur le bouton Retour

ReturnMainMenu:
	Gui, 2:submit,   									 ; fait disparaitre la fen�tre
	Gosub ShowMainWindow							 ; affiche le menu principal
return


;------------------------------------------------------------------------------
; cette fonction est lanc� quand on valide sur la liste, elle renvoie le choix dans la variable Choice et l'ex�cute


Valide:
	Gui, 2:Submit,NoHide
	GuiControlGet, ChoiceApp                             		; Renvoie le choix fait par l'utilisateur
	number := AppNumber%ChoiceApp%                          ; met dans la variable number le num�ro correspondant � l'applicatioh choisit
	AppPath := ProgPathItems%number%                       ; lis le chemin pour lancer le programme dans un tableau
	AppDir := ProgDirItems%number%                         ; lis le dossier de travail du programme dans un tableau
	; teste si le dossier de travail est sp�ciffi�
	if AppDir = False
	{
		Run, %AppPath%															; ex�cute le programme choisit par l'utilisateur
	}
	else
	{
		Run, %AppPath%, %Appdir%												; ex�cute le programme choisit par l'utilisateur
	}
return
;----------------------------------------------------------------------------------------------------------------------------------------

;  sub qui valide la liste des menus ou des programmes quand il n'y a pas de menus
ValideMenu:
	if Menus = 1
	{
		Gui, 1:submit,   									 ; fait disparaitre la fen�tre
		GuiControlGet, Choice                             ; Renvoie le choix fait par l'utilisateur
		llistitems = ""
		Gosub CreateAppsMenu				  ; raffraichit la liste avec les nouvelles valeurs
		Gosub ShowSubMenu								  ; raffiche le sous-menu
	}
	else
	{
		Gui, 1:Submit,NoHide
		GuiControlGet, Choice                             				; Renvoie le choix fait par l'utilisateur
		number := AppNumber%Choice%                 ; met dans la variable number le num�ro correspondant � l'applicatioh choisit
		AppPath := ProgPathItems%number%            ; lis le chemin pour lancer le programme dans un tableau
		AppDir := ProgDirItems%number%              ; lis le dossier de travail du programme dans un tableau
		if AppDir = False
		{
			Run, %AppPath%															; ex�cute le programme choisit par l'utilisateur
		}
		else
		{
			Run, %AppPath%, %Appdir%												; ex�cute le programme choisit par l'utilisateur
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
; cr�� un sous menu du menu de la zone de notification qui contiendra tous les programmes

CreateProgMenu:

	IniCount = 1									;Met a 1 le compteur des sections du tableau
	loop	; boucle sans fin se termine quand la valeur dans le tableau est fals ce qui signifie que c'est la fin du tableau
	{
		; on vas chercher les valeur dans le tableaux cr�er pr�c�dament 
		AppName := ProgNameItems%IniCount%        ; vas chercher le nom du programme dans le tableau et l'affecte � une variable
		if AppName = False							; si on arrive a la fin du fichier ini les variables sont remplit avec false,
		{
			break									; on sort de la boucle loop
		}
		menu, progs, add, %AppName%, RunMenuApp
		IniCount +=1								; on incr�mente le compteur d'application
	}

return


;-------------------------------------------------------------------
; Ex�cute les applications � partir du menu de la zone de notification

RunMenuApp:
	AppPath := ProgPathItems%A_ThisMenuItemPos%
	Run, %AppPath%
return



;----------------------------------------------------------------------
; affiche une msgbox avec un texte a propos du logiciel

HelpAbout:
	MsgBox, %NomDuScript% `n `nCe programme � �t� cr�� par  : `n `n `t - Luc SEGURA `n `t - Michel SUCH `n `t - Jeannot40 `n `n lissence : GPL `n
return


;----------------------------------------------------------------------------------

; minimise ou maximise la fen�tre du bureau portable

MinMax:
  if WinMin = 0
  {
      Menu, Tray, Rename, R�duire`t Ctrl+M, Agrandir`t Ctrl+M
      WinHide, %AppWin%
      WinMin = 1  
  }
  else
  {
      Menu, Tray, Rename, Agrandir`t Ctrl+M, R�duire`t Ctrl+M
      WinShow, %AppWin%
      WinActivate, %AppWin%
      WinMin = 0
  }

return

;-----------------------------------------------------------------

; sub qui v�rifie si un programme � �t� lanc� et demande si il doit �tre arr�t�

QuitQuest:
   if Stop <> false
   {   
        MsgBox, 4, , Voulez-vous quitter %StartAppName% ?
        IfMsgBox, Yes
        {
            if Stop <> False ; si le fichier ini sp�cifie qu'il faut arr�t� le programme qui � �t� d�mar�
            {
   	            Run, %Stop%        ; ex�cuter la commande sp�ciffi� dans la variable stop contenant la commande pour stoper le programme
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







