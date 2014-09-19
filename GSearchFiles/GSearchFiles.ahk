;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#NoTrayIcon   ; pas d'icône dans la zone de notification

; Créer le GUI principal avec une marge
Gui, Margin, 5, 5

; Choix de la police d'affichage du logiciel et de sa taille
Gui, Font, S12 CDefault, Arial

Gui, Add, GroupBox, x20 y10 w500 h80, Rechercher sur des services de stockage en ligne 
Gui, Add, Text, x40 y40 w150 h40, Rechercher :
Gui, Add, Edit, vSearchText x140 y40 w100 h20
Gui, Add, Text, x260 y40 w40 h20, Sur :
Gui, Add, ListBox, vServList x320 y40 w160 h20 AltSubmit, RapidShare|MegaUpload|Badongo|Médiafire|

Gui, Add, Button, gGoSearch x60 y105 w130 h30, Re&chercher
Gui, Add, Button, gGuiClose x330 y105 w130 h30, Qui&tter

Gui, Show, w540 h160, GSearchFiles

Return

; racourcits clavier

; racourcit pour quitter

!f4::
  GoSub GuiClose
return


;-----------------------------------------------------------------------------------------------------
;
;                              Sub du programme 
;
;-----------------------------------------------------------------------------------------------------


; sub qui lance la recherche selon le site choisit

GoSearch:
	Gui, Submit, NoHide

    
  
  if (SearchText <> "")
  {
    if ServList = 1     ; si le choix dans la liste est rapidshare
    {
        ; on met dans la variable googlerequest l'url de recherche avec au milieu la variable contenant la recherche
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22rapidshare.com/files%22 " 
        Run %GoogleRequest%     ; on exécute le lien qui est dans la variable googlerequest
        Return
    }
    if ServList = 2     ; si le choix dans la liste est megaupload 
    {
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22megaupload.com/?d=%22 " 
        Run %GoogleRequest%
        Return
    }
    if ServList = 3     ; si le choix dans la liste est badongo
    {
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22badongo.com/file/%22 " 
        Run %GoogleRequest%
        Return
    }
    if ServList = 4     ; si le choix dans la liste est Média Fire
    {
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22mediafire.com/?%22 " 
        Run %GoogleRequest%
        Return
    }
    else
    {
        MsgBox 48, attention !!!, Vous n'avez sélectionné aucun site !
    }
  }
  else
  {
    MsgBox 48, Attention www, Vous n'avez rien entré dans le champ de recherche
  }
Return

;--------------------------------------------------------------------------

; ferme le programme

GuiClose:  
   Gui, cancel
   GuiEscape:
   ExitApp










