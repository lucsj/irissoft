Version = r20
NomDuScript =  SkypeTalkingMenu  %Version%


;----------------------------------------------------------------------------------------------------------------------------------------
; Nom :				SkypeTalkingMenu
; Language:       	Français
; Platform:         WinXP, vista, Seven
; Auteurs:          Luc S, Michel Such
; AutoHotkey     	Version: 1.0.47
; Version :			Alpha rrelease 10
; Lissence :		GPL 3
; Description :		Menu des principales fonctions de SkypeTalking
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;
;
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>
;
;---------------------------------------------------------------------------------

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; petit encas textuel splash, qui indique le chargement du programme
SplashTextOn, , , Chargement en cours...

; lis les valeurs dans le fichier ini et les met dans des variables ou des tableaux
Gosub GetFromIniFile

; création du menu dans la zone de notiffication
Menu,Tray,Tip,%WinTitle%
Menu,Tray,NoStandard
Menu,Tray,Icon,SkypeTalkingMenu.ico
Menu,Tray,DeleteAll
Menu,Tray,Add,Afficher la liste des commandes`t AltGR+Espace,ShowList
Menu,Tray,Add,Fenêtre de lecture des messages écrits `t Window+Espace,ShowMsgWin
Menu,Tray,Add,
Menu,Tray,Add,&Quitter`t Windows+F4,GuiClose

;initialiser la fenêtre avec le texte et la liste
Gui, 1:Font, S13 CDefault, Arial		; Choix de la police d'affichage du logiciel et de sa taille
Gui, 1:Add, Text, x20 y4 w250 h20, Choisissez une commande :
Gui, 1:Add, ListBox, vchoix gDbleClick x20 y30 w550 h330 vscroll AltSubmit, %items%
;Gui, Add, ListView, gDbleClick vchoix x20 y30 r2 w500 h350 AltSubmit, Commande|Racourcis
Gui, 1:Add, Button, vSend gValide x585 y120 w100 h40 +Default, &Valider
Gui, 1:Add, Button, vCancel gclose x585 y220 w100 h40, &Quitter

Gui, 2:Font, S13 CDefault, Arial		; Choix de la police d'affichage du logiciel et de sa taille
Gui, 2:Add, GroupBox, x10 y20 w350 h220, Messages écrits à écouter
Gui, 2:Add, Text, x20 y50 w100 h180, Choisissez dans l'ordre d'ouverture des conversations, laquelle voulez-vous entendre
Gui, 2:Add, Text, x200 y50 w100 h180, Choisissez le message à écouter : sachant que le 1 est le dernier, le 2 l'avant dernier etc
Gui, 2:Add, Listbox, vconv x140 y50 w40 h180 vscroll AltSubmit, 1||2|3|4|5|6|7|8|9|
Gui, 2:Add, Listbox, vmsgs x300 y50 w40 h180 vscroll AltSubmit, 1||2|3|4|5|6|7|8|9|
Gui, 2:Add, Button, gConversation x10 y250 w160 h30, Choix Con&versation
Gui, 2:Add, Button, gLisMsg x200 y250 w160 h30, Lire &message
Gui, 2:Add, Button, gCopyMsg x10 y310 w160 h30, &Copier le message
Gui, 2:Add, Button, GActiveLink x200 y310 w160 h30, Activer le &lien


; le chargement est finit on arrête le splash texte
SplashTextOff



return


;------------------------------------------------------------------------------------------------
;
; Racourcis clavier
;
;------------------------------------------------------------------------------------------------

; Afficher la liste des commandes en appuyant sur Alt+Espace

^!Space::
   Gosub ShowList
return

;---------------------------------------------------------------------------------------------

; ouvrir la fenêtre de vocalisation des messages écrits

#Space::
   Gosub ShowMsgWin
return


; Quitter en appuyant sur Windows+f4

#F4::
   Gosub GuiClose
return 

#IfWinActive ahk_class AutoHotkeyGUI		; Active les racourcis clavier uniquement si la fenêtre du programme est active
   ;la touche échap a pour effet de Fermer la liste des commandes
   Escape::
        Gosub close
   return
#IfWinActive



;---------------------------------------------------------------------------------
;
;  Fonctions
;
;-----------------------------------------------------------------------------

; lis les valeurs dans le fichier ini et les met dans des variables ou des tableaux

GetFromIniFile:
		TabCount = 1
		; Le fichier .ini doit avoir le même nom que le programme
    	; ce qui permet de copier le programme sous des noms différents
    	; avec des .ini différents
    	SplitPath, A_ScriptName,,,, ScriptNoExt
    	ScriptIni = %ScriptNoExt%.ini
    	; vérification de l'existance du fichier ini
    	IfExist, %ScriptIni%
    	{
			IniRead WinTitle, %ScriptIni%, options, Titre, False 	;lit le titre de la fenêtre
			; lis le nom des programme et les met dans un tableau
			loop
			{
				IniRead CmdName, %ScriptIni%, cmd%TabCount%, CmdName, False 		;lit le nom de la commande
				IniRead CmdKey, %ScriptIni%, cmd%TabCount%, CmdKey, False		;lis le racourcis clavier à lancer
				IniRead CmdStringKey, %ScriptIni%, cmd%TabCount%, CmdStringKey, False	;lit le Lis le nom des touches de la commande
				CmdNameItems%TabCount% := CmdName		; Ajoute le nom de la commande dans un tableau
				CmdKeyItems%TabCount% := CmdKey			; Ajoute le racourcis à un tableau
				CmdStringKeyItems%TabCount% := CmdStringKey	; Ajoute le nom des touches de la commande à un tableau
				if CmdName = False				; si on arrive a la fin du fichier ini les variables sont remplit avec false,
				{
					break				; on sort de la boucle loop
				} 
			TabCount +=1
			}
		}
    	else
    	{
        	MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter
        	Gosub GuiClose     
    	}
		Gosub MakeCmdList
return

;--------------------------------------------------------------------------------------------------

; Créé la liste des commandes et de leur racourcis clavier


MakeCmdList:

	MenuCount = 1
	Loop		; boucle sans fin se termine uniquement quand il n'y a plu de menus
	{
	    	; on vas chercher les commande et leur racourcis dans le tableau créé précédament
	    	CmdName := CmdNameItems%MenuCount%		
			CmdStringKey := CmdStringKeyItems%MenuCount%		
	    	if CmdName = False						; si on arrive a la fin des menus les variables sont remplit avec false,
	    	{
        		break			; On est arrivé a la fin de la liste des menus, donc on sort de la boucle
	    	}
	    	if MenuCount = 1						; si c'est la première fois qu'on ajoute un élément a  la liste
	    	{
	        	items = %CmdName% - %CmdStringKey%||			; ajouter le nom du menu qu'on atrouvé dans le fichier ini
	    	}
 	    	else	; sinon dans tous les autres cas
	    	{
				items = %items%%CmdName% - %CmdStringKey%|			; on concatenne la liste avec les nouveaux éléments trouvés dans le fichier ini
	    	}
			;LV_Add("", CmdName, CmdStringKey)
			MenuCount +=1	; on incrémente le compteur d'application
	}
	;LV_ModifyCol()
Return




;--------------------------------------------------------------------------------

; Affiche la liste des commandes de skypetalking


ShowList:
	Gui, 1:Show, w700 h400, %Wintitle%
return


;---------------------------------------------

; valide l'une des fonctions de la liste et l'exécute

valide:
		Gui, 1:Submit,NoHide
		GuiControlGet, choix   		        	; Renvoie le choix fait par l'utilisateur
		Key := CmdKeyItems%choix%              ; met dans la variable Key le racourcis clavier corespondant
		Send %Key%								; envoie le racourcis clavier qui est dans la variable key

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
		gosub Valide

	}
return

;-----------------------------------------------------------------------------------

; cache la fenetre de la liste des commandes

close:

   Gui 1:cancel
   gui 2:cancel
   GuiEscape:

return

;--------------------------------------------------------------------------------------------------
; fonction qui affiche la fenêtre de lecture des messages écrits

ShowMsgWin:
	Gui, 2:Show, w380 h360, Vocalisation des Discussions écrite
Return

;-------------------------------------------------------------------------------------------------------------
; Sub qui change de fenêtre de conversation

Conversation:
		Gui, 2:Submit,NoHide
		GuiControlGet, conv   		        						; Renvoie le choix fait par l'utilisateur
		Key = ^+!{F%conv%}											; met dans la variable key  le racourcis clavier
		Send %Key%													; envoie le racourcis clavier qui est dans la variable key
Return

;--------------------------------------------------------------------------------------------------------
; Sub qui lis le message sélectionné de la conversation choisit.

LisMsg:
		Gui, 2:Submit,NoHide
		GuiControlGet, msgs   		        						; Renvoie le choix fait par l'utilisateur
		Key = ^+!%msgs%												; met dans la variable key le racourcis clavier
		Send %Key%													; envoie le racourcis clavier qui est dans la variable key

Return

;-------------------------------------------------------------------------------
; copi le message choisit

CopyMsg:
		Gui, 2:Submit,NoHide
		GuiControlGet, msgs   		        						; Renvoie le choix fait par l'utilisateur
		Key = ^+!%msgs%												; met dans la variable key le racourcis clavier
		Send %Key%%Key%												; envoie le racourcis clavier qui est dans la variable key

Return

;-------------------------------------------------------------------------------------
; Active le lien que contient le message choisit

ActiveLink:
		Gui, 2:Submit,NoHide
		GuiControlGet, msgs   		        						; Renvoie le choix fait par l'utilisateur
		Key = ^+!%msgs%												; met dans la variable key le racourcis clavier
		Send %Key%%Key%%Key%										; envoie le racourcis clavier qui est dans la variable key
Return

;---------------------------------------------------------------------

;Ferme le programme

GuiClose:
   ExitApp





