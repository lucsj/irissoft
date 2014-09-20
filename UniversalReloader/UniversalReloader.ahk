Version = 0.3.1
NomDuScript =  UniversalReloader  %Version%

; début du programme

;--------------------------------------------------------------------------------------------------------------------
; Nom :					    UniversalReloader
; Language:       	Français
; Platform:         WinXP, vista, Seven
; Auteurs:          Luc S, 
; AutoHotkey     		Version: 1.0.47
; Version :				  0.3
; Lissence :			  GPL 3
; Description :		  Relanceur de lecteurs d'écran, tant qu'ils ne sont pas arrêté il fait plusieurs tentatives pour les arrêter
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

; création du menu dans la zone de notiffication
Menu,Tray,Tip,%NomDuScript%
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Icon,UniversalReloader.ico
Menu,Tray,Add,&Relancer un lecteur d'écran `t Ctrl+Alt+U,SRReload
Menu,Tray,Add,
Menu,Tray,Add,&Configuration,ShowConfig
Menu,Tray,Add,&Aide,HELP
Menu,Tray,Add,&A propos,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Quitter,QuitApp


; initialise la boîte de dialogue de configuration 
; Créer le GUI principal avec une marge
  Gui, Margin, 5, 5

  ; Choix de la police d'affichage du logiciel et de sa taille
  Gui, Font, S12 CDefault, Arial

  Gui, 1:Add, GroupBox, x40 y10 w350 h70, Dossier d'installation de NVDA
  Gui, 1:Add, Edit, vNvdaPath x60 y40 w220 h20, 
  Gui, 1:Add, Button, gBrowsNvdaApp x290 y40 w90 h20, Parcourrir  
  Gui, 1:Add, GroupBox, x40 y90 w350 h70, Choix de la version de jaws
  Gui, 1:Add, Text, x60 y120 w220 h20, Choisissez la version de jaws :  
  Gui, 1:Add, ListBox, vSetJawsVersion x300 y120 w60 h20 vscroll , 10||11|12|13|14|15
  Gui, 1:Add, GroupBox, x40 y170 w350 h70, Si jaws et nvda sont démarrés ?
  Gui, 1:Add, Text, x60 y200 w220 h20, Choisissez lequel arrêter :  
  Gui, 1:Add, ListBox, vSetNvdaAndJaws x300 y200 w60 h20 vscroll , nvda||jaws
  Gui, 1:Add, Button, vSendConfig gValideConfig x90 y270 w120 h40 +Default, &Enregistrer 
  Gui, 1:Add, Button, vCancelConfig gCloseConfig x240 y270 w120 h40, &Annuler


	Gosub GetFromIniFile 		; lance la sub qui vas chercher les valeurs dans le fichier ini



return


;------------------------------------------------------------------------------------------------
;
; Racourcis clavier
;
;------------------------------------------------------------------------------------------------

; Redémarrer un des deux lecteur d'écran en appuyant sur Ctrl+Alt+U

^!u::
   Gosub SRReload
return

;---------------------------------------------------------------------------------------




;-----------------------------------------------------------------------------
;
;  subs
;
;-----------------------------------------------------------------------------

; sub principale qui vériffie quel lecteur d'écran est lancé et le redémarre

SRReload:

	; ce programme redémarre les lecteurs d'écran, dans le cas oû ils seraient bloqué ou ne fonctionneraient plu

	; initialise les variables
	jaws = 0
	nvda = 0

	; teste si jaws est lancé
	process, exist, jfw.exe		; vériffie l'existance du processus nomé jfw.exe
	if (ErrorLevel != 0) 		; si le processus existe
		jaws = 1				; on affecte la valeur 1 à la variable jaws pour signalé que jaws est en fonctionnement
	process, exist, nvda.exe		; vériffie l'existance du processus nomé nvda.exe
	if (ErrorLevel != 0)			; si le processus existe
		nvda = 1					; on affecte la valeur 1 à la variable nvda pour signalé que nvda est en fonctionnement
	
	; teste lequel des deux lecteur d'écran est lancé, si c'est les deux jaws sera fermé	
	if (nvda = 1 and jaws = 1) 		; si jaws et nvda fonctionnent tout deux en même temps
	{
		if GetNvdaAndJaws = nvda    ; si l'option qui spécifie quel lecteur d'écran arrêter est égale à nvda
		{
			Gosub CloseNvda		; lance la sub qui arrête nvda	
		}
		else if GetNvdaAndJaws = jaws  	; sinon si l'option qui spécifie quel lecteur d'écran arrêter est égale à jaws
		{
			Gosub CloseJaws		; lance la sub qui arrête jaws
		}
		else         ; si aucune option n'est spéciffié dans le fichier ini
		{
			Gosub CloseJaws		; lance la sub qui arrête jaws	
		}
	}
	else if (nvda = 1 and jaws = 0)		; teste si nvda est lancé et pas jaws
	{
		Gosub CloseNvda		; lance la sub qui arrête nvda
		Gosub LoadNvda		; relance nvda
		Sleep 3000		; attends 3 segondes
	}
	else if (nvda = 0 and jaws = 1)		; teste si jaws est lancé et pas nvda
	{
		Gosub CloseJaws		; lance la sub qui arrête jaws
		Gosub LoadJaws		; lance la sub qui redémarre jaws
		Sleep 3000		; attends 3 segondes
	}
	else 
	{
        MsgBox, aucun lecteur d'écran n'a été lancé
	}
	Sleep 3000			; attends 3 segondes
Return

;---------------------------------------------------------------------------------------------

; sub qui ouvre une boîte de dialogue de configuration

ShowConfig:

   ; affiche dans la boîte de dialogue les valeurs actuelles du fichier ini
   GuiControl, 1: , NvdaPath, %GetNvdaDir%
   if GetJawsVersion = 11
   {
      GuiControl, 1: , SetJawsVersion, 10|11||12|13|14|15   
   }
   else if GetJawsVersion = 12
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12||13|14|15      
   }
   else if GetJawsVersion = 13
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12|13||14|15      
   }
   else if GetJawsVersion = 14
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12|13|14||15      
   }
   else if GetJawsVersion = 15
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12|13|14|15||
   }
   
   if GetNvdaAndJaws = nvda
   {
        GuiControl, 1: , SetNvdaAndJaws, nvda||jaws
   }
   else if GetNvdaAndJaws = jaws
   {
        GuiControl, 1: , SetNvdaAndJaws, nvda|jaws||
   }
   
   ;GuiControl, 1: , SetNvdaAndJaws, %GetNvdaAndJaws%


   Gui, 1:Show, w460 h340, Configuration

Return

;---------------------------------------------------------------------------------------------

; sub qui exécute la configuration quand on clique sur le bouton ok

ValideConfig:

	Gui, 1:Submit

   GetNvdaDir = %NvdaPath%
   GetJawsVersion = %SetJawsVersion%
   GetNvdaAndJaws = %SetNvdaAndJaws%
   
   Gosub SetToIniFile              ;lance la sub qui écrit les valeurs choisits dans le fichier ini
   Sleep 3000		; attends 3 segondes   
   Gosub GetFromIniFile            ;Recharge les valeurs à partir du nouveau fichier ini

Return

;---------------------------------------------------------------------------------------------

; sub qui est lancé quand on appuy sur le bouton annuler dans la boîte de dialogue de configuration

CloseConfig:

   Gui 1:cancel


Return

;---------------------------------------------------------------------------------------------


; permet de choisir le dossier d'installation de nvda en cliquant sur le bouton parcourrir 

BrowsNvdaApp:

   FileSelectFolder, SetNvdaPath, , 3
   GuiControl, 1: , NvdaPath, %SetNvdaPath%
   
Return

;---------------------------------------------------------------------------------------------

; écrit les valeurs choisit dans le fichier ini

SetToIniFile:

    ; Le fichier .ini doit avoir le même nom que le programme
    SplitPath, A_ScriptName,,,, ScriptNoExt
    ScriptIni = %ScriptNoExt%.ini		; affecte à la variable ScriptINi le nom du programme sans extensions suivi de l'extension .ini
    ; vérification de l'existance du fichier ini
    IfExist, %ScriptIni%
    {
        IniWrite %GetNvdaDir%, %ScriptIni%, Options, NvdaDir		; lis et met dans la variable GetNvdaDir le dossier oû nvda est installé
        IniWrite %GetNvdaAndJaws%,  %ScriptIni%, Options, NvdaAndJaws	; lis l'option qui dit quel lecteur d'écran arrêté quand les deux fonctionnent
        IniWrite %GetJawsVersion%, %ScriptIni%, Options, JawsVersion	; lis la version de jaws qui servira à relancer jaws
    }
    else		; si le fichier ini n'a pas été trouvé
    {
        MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter	; affiche un message 
        Gosub QuitApp							; lance la sub qui quitte le programme
    }


Return

;---------------------------------------------------------------------------------------------

; vas chercher les options dans le fichier ini

GetFromIniFile:

    ; Le fichier .ini doit avoir le même nom que le programme
    SplitPath, A_ScriptName,,,, ScriptNoExt
    ScriptIni = %ScriptNoExt%.ini		; affecte à la variable ScriptINi le nom du programme sans extensions suivi de l'extension .ini
    ; vérification de l'existance du fichier ini
    IfExist, %ScriptIni%
    {
        IniRead GetNvdaDir, %ScriptIni%, Options, NvdaDir, False		; lis et met dans la variable GetNvdaDir le dossier oû nvda est installé
        IniRead GetNvdaAndJaws,  %ScriptIni%, Options, NvdaAndJaws, False	; lis l'option qui dit quel lecteur d'écran arrêté quand les deux fonctionnent
        IniRead GetJawsVersion, %ScriptIni%, Options, JawsVersion, False	; lis la version de jaws qui servira à relancer jaws
        IniRead GetReloadKey, %ScriptIni%, Options, ReloadKey, False
    }
    else		; si le fichier ini n'a pas été trouvé
    {
        MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter	; affiche un message 
        Gosub QuitApp							; lance la sub qui quitte le programme
    }

Return

;---------------------------------------------------------------------------------------------
; sub qui ferme nvda

CloseNvda:
Loop,		; boucle sans fin
	{
		process, exist, nvda.exe		; vériffie si le processus nvda.exe existe
		if (ErrorLevel = 0)			; si nvda à été arrêté avec succès
		   break				; on sort de la boucle
		
		if (GetNvdaDir != False)		; si le dossier de nvda est  spéciffié dans le fichier ini
		{
                	    	 RunWait, %GetNvdaDir%\nvda.exe -q	; lance une ligne de commande qui arrête nvda, et attends que son exécution se termine
                	}
                	Else	; si le dossier de nvda n'est pas spéciffié dans le fichier ini
                	{
                		process, Close, nvda.exe		; ancienne technique pour quitter nvda 
                	}
	}
Return


;---------------------------------------------------------------------------------------------
; sub qui ferme jaws

CloseJaws:
Loop,		; boucle sans fin
	{
		process, exist, jfw.exe	; vériffie si le processus jfw.exe existe 
		if (ErrorLevel = 0)		; si jaws à été arrêté avec succès
		   break			; on sort de la boucle
		process, Close, jfw.exe	; sinon on essai d'enlever jaws de la mémoire, tant qu'il n'est pas enlevé la boucle continue
	}
Return

;---------------------------------------------------------------------------------
; lance jaws

LoadJaws:
	SoundPlay, ding.wav	; joue un son système pour indiquer que jaws vas être relancé
	if (GetJawsVersion != False)
	{
	    jawsDir = C:\Program Files\Freedom Scientific\JAWS\%GetJawsVersion%.0\	; met dans la variable jawsDir le dossier de jaws en utilisant la version de jaws spécifié dans le fichier ini
	    Run %jawsDir%\jfw.exe			; lance jaws en exécutant son fichier
	}
	Else		; si la version de jaws n'est pas spéciffié dans le fichier ini
	{
		send ^!j					; ancienne façon de lancer jaws en lançan un appuy sur CTRL+ALT+J
	}
	
Return


;---------------------------------------------------------------------------------
; lance nvda

LoadNvda:
	SoundPlay, ding.wav					; joue un son système
	if (GetNvdaDir != False)			; si le dossier de nvda est spéciffié dans le fichier ini
	{
	     Run %GetNvdaDir%\nvda.exe			; exécute le fichier exe de nvda à partir du dossier spécifié dans le fichier ini
	}
	Else						; si le dossier n'est pas spéciffié dans le fichier ini
	{
	     send ^!n					; appuy sur  CTRL+ALT+N
	}
Return

; Fonction qui affiche une boîte d'aide

HELP:
	MsgBox, Utilisation du programme : `n `n Pour relancer Jaws ou Nvda quand ils sont bloqués, `n appuyez sur : `n`n CTRL+alt+U `t le lectteur d'écran sera arrêté et relancé, `n `n Merci d'avoir installé Universal Reloader
Return

; fonction qui affiche la boîte de dialogue a propos 

ABOUT:
      MsgBox, %NomDuScript% : `n est une application qui permet de relancer Nvda ou Jaws si ils sont bloqués, `n ce petit programme sans prétention vous aidera à reprendre la main sur votre ordinateur quand il bloque `n  `n Merci d'avoir installer ce programme IrisSoft vous remercie.
Return


;--------------------------------------------------------------------------------

; quitte le programme

QuitApp:
        ExitApp	; quitte le programme





