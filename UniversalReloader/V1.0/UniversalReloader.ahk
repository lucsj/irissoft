Version = 1.0 alpha 1
NomDuScript =  UniversalReloader  %Version%

; début du programme

;--------------------------------------------------------------------------------------------------------------------
; Nom :			UniversalReloader
; Language:       	Français
; Platform:         	WinXP, vista, Seven
; Auteurs:          	Luc S, 
; AutoHotkey     	Version: 1.0.47
; Version :		1.0 alpha 1
; Lissence :		GPL 3
; Description :		Relanceur de lecteurs d'écran, tant qu'ils ne sont pas arrêté il fait plusieurs tentatives pour les arrêter
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


; inclu les fonctions utilisées dans ce programme
#Include UrFnc.ahk

Gosub GetFromIniFile 		; lance la sub qui vas chercher les valeurs dans le fichier ini
; Lancement d'une fonction qui retourne un raccourcis clavier de manière compréhensive pour l'affichage
; renvoyer le racourcis clavier pour relancer jaws ou nvda affin de l'afficher dans le menu
ShowReloadKey := GetShowKey(GetReloadKey)
; renvoyer le racourcis clavier pour relancer firefox afin de l'aficher dans le menu
ShowReloadFfKey := GetShowKey(GetReloadFfKey)

 
 
 
; création du menu dans la zone de notiffication
Menu,Tray,Tip,%NomDuScript%
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Icon,UniversalReloader.ico
Menu,Tray,Add,&Relancer un lecteur d'écran `t %ShowReloadKey%,SRReload
Menu,Tray,Add,Relancer Mozilla Firefox `t %ShowReloadFfKey%,ReloadFf
Menu,Tray,Add,
Menu,Tray,Add,&Configuration `t Ctrl+Maj+C ,ShowConfig
Menu,Tray,Add,Détection de la version de Jaws `t Ctrl+Maj+D ,FindLastJawsVersion
Menu,Tray,Add,&Editer le fichier log  `t Ctrl+Maj+L ,EditLogFile
Menu,Tray,Add,&Aide,HELP
Menu,Tray,Add,&A propos,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Quitter `t Ctrl+Alt+F4,QuitApp





; initialise la boîte de dialogue de configuration 
; Créer le GUI principal avec une marge
  Gui, 1:Margin, 5, 5

  ; Choix de la police d'affichage du logiciel et de sa taille
  Gui, 1:Font, S12 CDefault, Arial

  Gui, 1:Add, tab, x0 y0 w350 h20,Lecteurs d'écran|Mozilla ; les onglets
  Gui, tab, 1  ; premier onglet
  Gui, 1:Add, GroupBox, x40 y28 w350 h70, Dossier d'installation de NVDA
  Gui, 1:Add, Edit, vNvdaPath x60 y58 w220 h20, 
  Gui, 1:Add, Button, gBrowsNvdaApp x290 y58 w90 h20, Parcourrir  
  Gui, 1:Add, GroupBox, x40 y108 w350 h70, Choix de la version de jaws
  Gui, 1:Add, Text, x60 y138 w220 h20, Choisissez la version de jaws :  
  Gui, 1:Add, ListBox, vSetJawsVersion x300 y138 w60 h20 vscroll , 10||11|12|13|14|15|16
  Gui, 1:Add, GroupBox, x40 y188 w350 h70, Si jaws et nvda sont démarrés ?
  Gui, 1:Add, Text, x60 y210 w228 h20, Choisissez lequel arrêter :  
  Gui, 1:Add, ListBox, vSetNvdaAndJaws x300 y218 w60 h20 vscroll , nvda||jaws
  Gui, 1:Add, GroupBox, x40 y268 w350 h70, Racourci de relance d'un lecteur d'écran 
  Gui, 1:Add, CheckBox, vctrl x60 y298 w50 h20, Ctrl
  Gui, 1:Add, CheckBox, valt x110 y298 w50 h20, Alt
  Gui, 1:Add, CheckBox, vmaj x160 y298 w50 h20, Maj
  Gui, 1:Add, CheckBox, vwin x210 y298 w50 h20, Win
  Gui, 1:Add, Edit, vKey x270 y298 w60 h20,
  Gui, 1:Add, Button, gValideConfig x90 y350 w120 h40 +Default, &Enregistrer 
  Gui, 1:Add, Button,  gCloseConfig x240 y350 w120 h40, &Annuler
  
  Gui, Tab, 2   ; deuxième onglet
  Gui, 1:Add, GroupBox, x40 y28 w350 h70, Dossier d'installation de Firefox
  Gui, 1:Add, Edit, vFirefoxPath x60 y58 w220 h20, 
  Gui, 1:Add, Button, gBrowsFirefoxApp x290 y58 w90 h20, Parcourrir  
  Gui, 1:Add, Button, gValideConfig x90 y350 w120 h40 +Default, &Enregistrer 
  Gui, 1:Add, Button, gCloseConfig x240 y350 w120 h40, &Annuler


return





;------------------------------------------------------------------------------------------------
;
; Racourcis clavier du programme
;
;------------------------------------------------------------------------------------------------


; quitte le programme quand on appuie sur ctrl alt f4
^!f4::
	Gosub QuitApp
return

; Ouvre la boîte de dialogue de configuration
^+c::
	Gosub ShowConfig
return

; Editer le fichier log
^+l::
	Gosub EditLogFile
return

; Détecter et choisir la version de jaws installé qu'on utilise
^+d::	
	Gosub FindLastJawsVersion
return




;-----------------------------------------------------------------------------
;
;  subs
;
;-----------------------------------------------------------------------------



; Sub principale qui vériffie quel lecteur d'écran est lancé et le redémarre

SRReload:

	; ce programme redémarre les lecteurs d'écran, dans le cas oû ils seraient bloqué ou ne fonctionneraient plu
	; initialise les variables
	jaws = 0
	nvda = 0
	jawsDir = C:\Program Files\Freedom Scientific\JAWS\%GetJawsVersion%.0\	; met dans la variable jawsDir le dossier de jaws en utilisant la version de jaws spécifié dans le fichier ini
	; teste si jaws est lancé
	jaws := IfProcessExist("jfw")		; vériffie l'existance du processus nomé jfw.exe
	nvda := IfProcessExist("nvda")	; vériffie l'existance du processus nomé nvda.exe	
	
	; teste lequel des deux lecteur d'écran est lancé, si c'est les deux jaws sera fermé	
	if (nvda = 1 and jaws = 1) 		; si jaws et nvda fonctionnent tout deux en même temps
	{
		if GetNvdaAndJaws = nvda    ; si l'option qui spécifie quel lecteur d'écran arrêter est égale à nvda
		{
			ClosePrg("nvda")		; arrête nvda en utilisant la fonction d'arrêt d'un programme le nom du programme sans son extenssion est passé en paramètre
		}
		else if GetNvdaAndJaws = jaws  	; sinon si l'option qui spécifie quel lecteur d'écran arrêter est égale à jaws
		{
			ClosePrg("jfw")		; arrête jaws en utilisant la fonction d'arrêt d'un programme le nom du programme sans son extenssion est passé en paramètre
		}
		else         ; si aucune option n'est spéciffié dans le fichier ini
		{
			ClosePrg("jfw")		; arrête jaws en utilisant la fonction d'arrêt d'un programme le nom du programme sans son extenssion est passé en paramètre
		}
	}
	else if (nvda = 1 and jaws = 0)		; teste si nvda est lancé et pas jaws
	{
		ClosePrg("nvda")		; arrête nvda en utilisant la fonction d'arrêt d'un programme le nom du programme sans son extenssion est passé en paramètre
		SoundPlay, sound/ding.wav					; joue un son système
		LoadProg(GetNvdaDir, "nvda")		; lance le programme dont le dossier et le nom sans extenssion sont passé en paramètre
		Sleep 3000		; attends 3 segondes
	}
	else if (nvda = 0 and jaws = 1)		; teste si jaws est lancé et pas nvda
	{
		ClosePrg("jfw")		; arrête jaws en utilisant la fonction d'arrêt d'un programme le nom du programme sans son extenssion est passé en paramètre
		SoundPlay, sound/ding.wav					; joue un son système
		LoadProg(jawsDir, "jfw")		; lance le programme dont le dossier et le nom sans extenssion sont passé en paramètre
		Sleep 3000		; attends 3 segondes
	}
	else 
	{
        MsgBox, aucun lecteur d'écran n'a été lancé
	}
	Sleep 3000			; attends 3 segondes
Return

;---------------------------------------------------------------------------------------------




;---------------------------------------------------------------------------------------------

; sub qui ouvre une boîte de dialogue de configuration

ShowConfig:

   ; affiche dans la boîte de dialogue les valeurs actuelles du fichier ini
   GuiControl, 1: , NvdaPath, %GetNvdaDir%
   GuiControl, 1: , FirefoxPath, %GetFirefoxDir%
   if GetJawsVersion = 11
   {
      GuiControl, 1: , SetJawsVersion, 10|11||12|13|14|15|16
   }
   else if GetJawsVersion = 12
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12||13|14|15|16
   }
   else if GetJawsVersion = 13
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12|13||14|15|16      
   }
   else if GetJawsVersion = 14
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12|13|14||15|16      
   }
   else if GetJawsVersion = 15
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12|13|14|15||16
   }
   else if GetJawsVersion = 16
   {
      GuiControl, 1: , SetJawsVersion, 10|11|12|13|14|15|16||
   }
   
   
   if GetNvdaAndJaws = nvda
   {
        GuiControl, 1: , SetNvdaAndJaws, nvda||jaws
   }
   else if GetNvdaAndJaws = jaws
   {
        GuiControl, 1: , SetNvdaAndJaws, nvda|jaws||
   }
   
    StringLen, KeyLen, GetReloadKey
    if KeyLen = 3
    {
        StringMid, Key1, GetReloadKey, 1, 1
        StringMid, Key2, GetReloadKey, 2, 1
        StringMid, Key3, GetReloadKey, 3, 1
        if Key1 = ^
        {
            Guicontrol, 1: , Ctrl, 1        
        }
        else if key1 = !
        {
            Guicontrol, 1: , Alt, 1        
        }
        else if key1 = #
        {
            Guicontrol, 1: , Win, 1
        }
        Else if key1 = +
        {
            Guicontrol, 1: , Maj, 1
        }
        if Key2 = ^
        {
            Guicontrol, 1: , Ctrl, 1        
        }
        else if key2 = !
        {
            Guicontrol, 1: , Alt, 1        
        }
        else if key2 = #
        {
            Guicontrol, 1: , Win, 1
        }
        Else if key2 = +
        {
            Guicontrol, 1: , Maj, 1
        }
        GuiControl, 1: , Key, %key3%
    }
    else if KeyLen = 4
    {
        StringMid, Key1, GetReloadKey, 1, 1
        StringMid, Key2, GetReloadKey, 2, 1
        StringMid, Key3, GetReloadKey, 3, 1
        StringMid, Key4, GetReloadKey, 4, 1
        if Key1 = ^
        {
            Guicontrol, 1: , Ctrl, 1        
        }
        else if key1 = !
        {
            Guicontrol, 1: , Alt, 1        
        }
        else if key1 = #
        {
            Guicontrol, 1: , Win, 1
        }
        Else if key1 = +
        {
            Guicontrol, 1: , Maj, 1
        }
        if Key2 = ^
        {
            Guicontrol, 1: , Ctrl, 1        
        }
        else if key2 = !
        {
            Guicontrol, 1: , Alt, 1        
        }
        else if key2 = #
        {
            Guicontrol, 1: , Win, 1
        }
        Else if key2 = +
        {
            Guicontrol, 1: , Maj, 1
        }
        if Key3 = ^
        {
            Guicontrol, 1: , Ctrl, 1        
        }
        else if key3 = !
        {
            Guicontrol, 1: , Alt, 1        
        }
        else if key3 = #
        {
            Guicontrol, 1: , Win, 1
        }
        Else if key3 = +
        {
            Guicontrol, 1: , Maj, 1
        }
        GuiControl, 1: , Key, %key4%
    }

   Gui, 1:Show, w460 h400, Configuration

Return

;---------------------------------------------------------------------------------------------


; sub qui exécute la configuration quand on clique sur le bouton ok

ValideConfig:

  Gui, 1:Submit

  ;remettre les anciennes valeurs à zéro
  GetCtrl =
  GetAlt =
  GetWin =
  GetMaj =


   if ctrl = 1
   {
      GetCtrl = ^   
   }
   if alt = 1
   {
      GetAlt = !
   }
   if win = 1
   {
     GetWin = #
   }
   if maj = 1
   {
     GetMaj = +
   }
   StringLen, KeyLen, Key
   if KeyLen > 1
   {
       lettre = 1
   }
   GetReloadKey = %GetCtrl%%GetAlt%%GetWin%%GetMaj%%Key%
   StringLen, KeyLen, GetReloadKey
   if KeyLen > 4
   {
     touche = 1
   }
   Else if KeyLen < 3
   {
   		petit = 1
   }
   GetNvdaDir = %NvdaPath%
   GetFirefoxDir = %FirefoxPath%
   
   GetJawsVersion = %SetJawsVersion%
   GetNvdaAndJaws = %SetNvdaAndJaws%
   if lettre = 1
   {
       Msgbox, vous avez entré plus de deux lettre pour le racourcis clavier, il en faut qu'une, veuillez recommencer.    
       lettre = 0
       erreur = 1
   }
   if touche = 1
   {
       Msgbox, vous avez choisit plus de 4 touches pour votre raccourcis clavier, le programme ne prends pas en compte plus de 4 touches, veuillez recommencer   
       touche = 0
       erreur = 1
   }
   if petit = 1 
   {
   	   MsgBox Attention vous n'avez coché qu'une touche de racourcis il faut en cocher deux ou trois, veuillez recommencer.
   	   petit = 0
   	   erreur = 1
   }   
   if erreur = 1 
   {
       erreur = 0
       Gosub ShowConfig
       Return
   }   
   Gosub SetToIniFile           						;lance la sub qui écrit les valeurs choisits dans le fichier ini
   Sleep 3000											; attends 3 segondes   
   Gosub GetFromIniFile        							; Recharge les valeurs à partir du nouveau fichier ini
   ShowReloadKey := GetShowKey(GetReloadKey)        	; renvoyer le racourcis clavier pour relancer jaws ou nvda affin de l'afficher dans le menu
   ShowReloadFfKey := GetShowKey(GetReloadFfKey)		; renvoyer le racourcis clavier pour relancer firefox afin de l'aficher dans le menu

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


;-------------------------------------------------------------------------------------------------------

; Permet de choisir le dossier d'installation de Firefox en cliquant sur  le bouton parcourrir

BrowsFirefoxApp:

   FileSelectFolder, SetFirefoxPath, , 3
   GuiControl, 1: , FirefoxPath, %SetFirefoxPath%
   
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
        IniWrite %GetNvdaDir%, %ScriptIni%, Options, NvdaDir		; écrit  le dossier oû nvda est installé
		IniWrite %GetFirefoxDir%, %ScriptIni%, Options, FirefoxPath		; écrit  le dossier oû nvda est installé
        IniWrite %GetNvdaAndJaws%,  %ScriptIni%, Options, NvdaAndJaws	; écrit l'option qui dit quel lecteur d'écran arrêté quand les deux fonctionnent
        IniWrite %GetJawsVersion%, %ScriptIni%, Options, JawsVersion	; écrit la version de jaws qui sera relancé
        IniWrite %GetReloadKey%, %ScriptIni%, Options, ReloadKey	; écrit le racourcis clavier qui servira à relancer le lecteur d'écran bloqué        
		
    }
    else		; si le fichier ini n'a pas été trouvé
    {
        MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter	; affiche un message 
        Gosub QuitApp							; lance la sub qui quitte le programme
    }


Return

;---------------------------------------------------------------------------------------------


; Sub qui vas chercher les options dans le fichier ini

GetFromIniFile:

    ; Le fichier .ini doit avoir le même nom que le programme
    SplitPath, A_ScriptName,,,, ScriptNoExt
    ScriptIni = %ScriptNoExt%.ini		; affecte à la variable ScriptINi le nom du programme sans extensions suivi de l'extension .ini
    ; vérification de l'existance du fichier ini
    IfExist, %ScriptIni%
    {
	 IniRead GetFirefoxDir, %ScriptIni%, Options, FirefoxDir, False   ; lis le dossier de firefox dans le fichier ini
        IniRead GetNvdaDir, %ScriptIni%, Options, NvdaDir, False		; lis et met dans la variable GetNvdaDir le dossier oû nvda est installé
        IniRead GetNvdaAndJaws,  %ScriptIni%, Options, NvdaAndJaws, False	; lis l'option qui dit quel lecteur d'écran arrêté quand les deux fonctionnent
        IniRead GetJawsVersion, %ScriptIni%, Options, JawsVersion, False	; lis la version de jaws qui servira à relancer jaws
        IniRead GetReloadKey, %ScriptIni%, Options, ReloadKey, False	; lis le racourcis clavier qui servira à relancer le lecteur d'écran bloqué
        IniRead GetReloadFfKey, %ScriptIni%, Options, ReloadFfKey, False	; lis le racourcis clavier qui servira à relancer le lecteur d'écran bloqué		
    }
    else		; si le fichier ini n'a pas été trouvé
    {
        MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter	; affiche un message 
        Gosub QuitApp							; lance la sub qui quitte le programme
    }
    HotKey,%GetReloadKey%,SRReload
    HotKey,%GetReloadFfKey%,ReloadFf	
Return


;--------------------------------------------------------------------------------------------------------------------------
; sub qui redémarre Firefox
ReloadFf:

firefox := IfProcessExist("firefox")	; vériffie l'existance du processus nomé firefox.exe
if (firefox = 0)
{
	MsgBox, Firefox n'est pas en fonctionnement actuellement
	Return
}

ClosePrg("firefox")		; arrête firefox en utilisant la fonction d'arrêt d'un programme le nom du programme sans son extenssion est passé en paramètre
SoundPlay, sound/ding.wav					; joue un son système
LoadProg(GetFirefoxDir, "firefox")		; lance le programme dont le dossier et le nom sans extenssion sont passé en paramètre	
Return

;--------------------------------------------------------------------------------------------------------------------------

; sub qui détecte la dernière version de jaws installé

FindLastJawsVersion:
	Loop, HKEY_LOCAL_MACHINE, SOFTWARE\Freedom Scientific\JAWS, 2, 1
	{
		if A_LoopRegName = 10.0
		{
			LastJawsVersion = 10
			Msgbox, 4, , , Jaws version %LastJawsVersion% à été détecté sur votre ordinateur, voulez-vous utiliser cette version ?
			IfMsgBox, YES, break
		}
		else if A_LoopRegName = 11.0
		{
			LastJawsVersion = 11
			Msgbox, 4, , , Jaws version %LastJawsVersion% à été détecté sur votre ordinateur, voulez-vous utiliser cette version ?
			IfMsgBox, YES, break
		}
		else if A_LoopRegName = 12.0
		{
			LastJawsVersion = 12
			Msgbox, 4, , , Jaws version %LastJawsVersion% à été détecté sur votre ordinateur, voulez-vous utiliser cette version ?
			IfMsgBox, YES, break
		}
		else if A_LoopRegName = 13.0
		{
			LastJawsVersion = 13
			Msgbox, 4, , , Jaws version %LastJawsVersion% à été détecté sur votre ordinateur, voulez-vous utiliser cette version ?
			IfMsgBox, YES, break
		}
		else if A_LoopRegName = 14.0
		{
			LastJawsVersion = 14
			Msgbox, 4, , , Jaws version %LastJawsVersion% à été détecté sur votre ordinateur, voulez-vous utiliser cette version ?
			IfMsgBox, YES, break			
		}
		else if A_LoopRegName = 15.0
		{
			LastJawsVersion = 15
			Msgbox, 4, , , Jaws version %LastJawsVersion% à été détecté sur votre ordinateur, voulez-vous utiliser cette version ?
			IfMsgBox, YES, break
		
		}
		else if A_LoopRegName = 16.0
		{
			LastJawsVersion = 16
		}
		else
		{
			MsgBox, Aucune version de jaws n'est installé sur votre ordinateur
		}
	}
	SetJawsVersion = %LastJawsVersion%
	GetJawsVersion = %SetJawsVersion%	
	Msgbox, La version de Jaws que vous utilisez est Jaws version %GetJawsVersion% 
	Gosub SetToIniFile           						;lance la sub qui écrit les valeurs choisits dans le fichier ini
    Sleep 3000											; attends 3 segondes   
    Gosub GetFromIniFile        							; Recharge les valeurs à partir du nouveau fichier ini
Return

;-------------------------------------------------------------------------------------------------------------------------------------

; sub qui affiche une boîte d'aide

HELP:
	MsgBox, Utilisation du programme : `n `n Pour relancer Jaws ou Nvda quand ils sont bloqués, `n appuyez sur : `n`n CTRL+alt+R (ou autre) `t le lectteur d'écran sera arrêté et relancé, `n `n Merci d'avoir installé Universal Reloader
Return

; fonction qui affiche la boîte de dialogue a propos 

ABOUT:
      MsgBox, %NomDuScript% : `n est une application qui permet de relancer Nvda ou Jaws si ils sont bloqués, `n ce petit programme sans prétention vous aidera à reprendre la main sur votre ordinateur quand il bloque `n  `n Merci d'avoir installer ce programme IrisSoft vous remercie.
Return

;------------------------------------------------------------------------------

; affiche le fichier log
EditLogFile:
	Run, UniversalReloader.log
return


;--------------------------------------------------------------------------------

; quitte le programme

QuitApp:
        ExitApp	; quitte le programme