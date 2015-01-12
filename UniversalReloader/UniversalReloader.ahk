Version = 0.5
NomDuScript =  UniversalReloader  %Version%

; début du programme

;--------------------------------------------------------------------------------------------------------------------
; Nom :				UniversalReloader
; Language:       	Français
; Platform:         WinXP, vista, Seven
; Auteurs:          Luc S, 
; AutoHotkey     	Version: 1.0.47
; Version :			0.5
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

Gosub GetFromIniFile 		; lance la sub qui vas chercher les valeurs dans le fichier ini
Gosub Setkey            ; lance la sub qui affiche de manière compréhensible le raccourcis clavier pour relancer le lecteur d'écran


; création du menu dans la zone de notiffication
Menu,Tray,Tip,%NomDuScript%
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Icon,UniversalReloader.ico
Menu,Tray,Add,&Relancer un lecteur d'écran `t %ShowReloadKey%,SRReload
Menu,Tray,Add,Relancer Mozilla Firefox `t Ctrl+Alt+F,ReloadFf
Menu,Tray,Add,
Menu,Tray,Add,&Configuration,ShowConfig
Menu,Tray,Add,&Aide,HELP
Menu,Tray,Add,&A propos,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Quitter,QuitApp


; initialise la boîte de dialogue de configuration 
; Créer le GUI principal avec une marge
  Gui, 1:Margin, 5, 5

  ; Choix de la police d'affichage du logiciel et de sa taille
  Gui, 1:Font, S12 CDefault, Arial

  Gui, 1:Add, GroupBox, x40 y10 w350 h70, Dossier d'installation de NVDA
  Gui, 1:Add, Edit, vNvdaPath x60 y40 w220 h20, 
  Gui, 1:Add, Button, gBrowsNvdaApp x290 y40 w90 h20, Parcourrir  
  Gui, 1:Add, GroupBox, x40 y90 w350 h70, Choix de la version de jaws
  Gui, 1:Add, Text, x60 y120 w220 h20, Choisissez la version de jaws :  
  Gui, 1:Add, ListBox, vSetJawsVersion x300 y120 w60 h20 vscroll , 10||11|12|13|14|15
  Gui, 1:Add, GroupBox, x40 y170 w350 h70, Si jaws et nvda sont démarrés ?
  Gui, 1:Add, Text, x60 y200 w220 h20, Choisissez lequel arrêter :  
  Gui, 1:Add, ListBox, vSetNvdaAndJaws x300 y200 w60 h20 vscroll , nvda||jaws
  Gui, 1:Add, GroupBox, x40 y250 w350 h70, Racourci de relance d'un lecteur d'écran 
  Gui, 1:Add, CheckBox, vctrl x60 y280 w50 h20, Ctrl
  Gui, 1:Add, CheckBox, valt x110 y280 w50 h20, Alt
  Gui, 1:Add, CheckBox, vmaj x160 y280 w50 h20, Maj
  Gui, 1:Add, CheckBox, vwin x210 y280 w50 h20, Win
  Gui, 1:Add, Edit, vKey x270 y280 w60 h20,
  Gui, 1:Add, Button, vSendConfig gValideConfig x90 y340 w120 h40 +Default, &Enregistrer 
  Gui, 1:Add, Button, vCancelConfig gCloseConfig x240 y340 w120 h40, &Annuler



return


;------------------------------------------------------------------------------------------------
;
; Racourcis clavier du programme
;

; Redémarre Mozilla Firefox quand on appuye sur Ctrl+Alt+F
^!f::
	Gosub ReloadFf
return

; quitte le programme quand on appuie sur ctrl alt f4
^!f4::
	Gosub QuitApp
return


;-----------------------------------------------------------------------------
;
;  subs
;
;-----------------------------------------------------------------------------

; sub qui affiche le raccourcis clavier pour relancer le lecteur d'écran de manière compréhensive
Setkey:

    StringLen, KeyLen, GetReloadKey
    if KeyLen = 3
    {
        StringMid, Key1, GetReloadKey, 1, 1
        StringMid, Key2, GetReloadKey, 2, 1
        StringMid, Key3, GetReloadKey, 3, 1
        if Key1 = ^
        {
            kb1 = Ctrl
        }
        else if key1 = !
        {
            kb1 = Alt
        }
        else if key1 = #
        {
            kb1 = Win
        }
        Else if key1 = +
        {
            kb1 = Maj
        }
        if Key2 = ^
        {
            kb2 = Ctrl
        }
        else if key2 = !
        {
            kb2 = Alt
        }
        else if key2 = #
        {
            kb2 = Win
        }
        Else if key2 = +
        {
            kb2 = Maj
        }
        ShowReloadKey = %kb1%+%kb2%+%key3%
    }
    else if KeyLen = 4
    {
        StringMid, Key1, GetReloadKey, 1, 1
        StringMid, Key2, GetReloadKey, 2, 1
        StringMid, Key3, GetReloadKey, 3, 1
        StringMid, Key4, GetReloadKey, 4, 1
        if Key1 = ^
        {
            kb1 = Ctrl
        }
        else if key1 = !
        {
            kb1 = Alt
        }
        else if key1 = #
        {
            kb1 = Win
        }
        Else if key1 = +
        {
            kb1 = Maj
        }
        if Key2 = ^
        {
            kb2 = Ctrl
        }
        else if key2 = !
        {
            kb2 = Alt
        }
        else if key2 = #
        {
            kb2 = Win
        }
        Else if key2 = +
        {
            kb2 = Maj
        }
        if Key3 = ^
        {
            kb3 = Ctrl
        }
        else if key3 = !
        {
            kb3 = Alt
        }
        else if key3 = #
        {
            kb3 = Win
        }
        Else if key3 = +
        {
            kb3 = Maj
        }
        ShowReloadKey = %kb1%+%kb2%+%kb3%+%key4%
    }





Return


;-----------------------------------------------------------------------------------

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
   Gosub SetToIniFile           ;lance la sub qui écrit les valeurs choisits dans le fichier ini
   Sleep 3000					; attends 3 segondes   
   Gosub GetFromIniFile         ;Recharge les valeurs à partir du nouveau fichier ini
   Gosub Setkey            		; lance la sub qui affiche de manière compréhensible le raccourcis clavier pour relancer le lecteur d'écran

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
        IniWrite %GetNvdaDir%, %ScriptIni%, Options, NvdaDir		; écrit  le dossier oû nvda est installé
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

; vas chercher les options dans le fichier ini

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
    }
    else		; si le fichier ini n'a pas été trouvé
    {
        MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter	; affiche un message 
        Gosub QuitApp							; lance la sub qui quitte le programme
    }
    HotKey,%GetReloadKey%,SRReload
Return

;--------------------------------------------------------------------------------------------------------------------------
; sub qui redémarre Firefox
ReloadFf:

process, exist, firefox.exe	; vériffie si le processus firefox.exe existe 
if (ErrorLevel = 0)
{
	MsgBox, Firefox n'est pas en fonctionnement actuellement
	Return
}



Loop,		; boucle sans fin
	{
		process, exist, firefox.exe	; vériffie si le processus firefox.exe existe 
		if (ErrorLevel = 0)		; si firefox à été arrêté avec succès
		{
		   if (A_Index > 1)  ; ajoute les informations au log si ça fait plus d'une fois qu'on tente d'arrêter firefox
		   {
		      MajLog("firefox", "stopped", "UniversalReloader.log")  ; on écrit dans le log que firefox s'est bien arrêté
		   }
		   break			; on sort de la boucle
		}
		else
		{
		   if (A_Index > 1)  ; ajoute les informations au log sauf la première tentative d'arrêt 
		   {
		      MajLog("firefox", "nostopped", "UniversalReloader.log")   ; ajoute au log que firefox n'as pas été arrêté
		   }
		}
		process, Close, firefox.exe	; on essai d'enlever firefox de la mémoire, tant qu'il n'est pas enlevé la boucle continue
	}

	SoundPlay, ding.wav					; joue un son système
	if (GetFirefoxDir != False)			; si le dossier de firefox est spéciffié dans le fichier ini
	{
	     Run %GetFirefoxDir%\firefox.exe			; exécute le fichier exe de nvda à partir du dossier spécifié dans le fichier ini
	}
	Else						; si le dossier n'est pas spéciffié dans le fichier ini
	{
	     Run C:\Program Files (x86)\Mozilla Firefox\firefox.exe			; exécute le fichier exe de nvda à partir du dossier spécifié dans le fichier ini
	}
	
Return



;---------------------------------------------------------------------------------------------
; sub qui ferme nvda

CloseNvda:
Loop,		; boucle sans fin
	{
		process, exist, nvda.exe		; vériffie si le processus nvda.exe existe
		if (ErrorLevel = 0)			; si nvda à été arrêté avec succès
		{
		   if (A_Index > 1)
		   {
		      MajLog("nvda", "stopped", "UniversalReloader.log")
		   }
		   break				; on sort de la boucle
		}
		else     
		{
		   if (A_Index > 1)
		   {
		      MajLog("nvda", "nostopped", "UniversalReloader.log")
		   }
		}
		
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
		{
		   if (A_Index > 1)
		   {
		      MajLog("jaws", "stopped", "UniversalReloader.log")  ; on écrit dans le log que jaws s'est bien arrêté
		   }
		   break			; on sort de la boucle
		}
		else
		{
		   if (A_Index > 1)
		   {
		      MajLog("jaws", "nostopped", "UniversalReloader.log")
		   }
		}
		   
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



		
		
		
		
		
		
;------------------------------------------------------------------------------------------------------
;
;    Fonctions du programme
;
;------------------------------------------------------------------------------------------------

; fonction qui écrit un fichier log dont le nom est passé en paramètre
; exemple d'utilisation MajLog("nvda", "stoped", "UniversalReloader.log")


		
MajLog(id, state, logfile)
{
    FormatTime, vdate, ddMMyyyy, HH:mm:ss dd/MM/yyyy
    FileAppend,%vdate% | %id% %state% `n , %logfile%
}



