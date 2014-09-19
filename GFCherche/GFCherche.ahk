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
; AutoHotkey Version: 1.x
; Language:       French
; Platform:       Win9x/NT
; Author:         IrisSoft
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
Gui, Add, ListBox, vServList x320 y40 w160 h20 AltSubmit, RapidShare||Mega|Badongo|Médiafire|Dropbox|Free|anyhub

Gui, Add, Button, gGoSearch x60 y105 w130 h30 +Default, Re&chercher
Gui, Add, Button, gGuiClose x330 y105 w130 h30, Qui&tter

Gui, Show, w540 h160, GFCherche 1.0

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
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22mega.co.nz%2F%23!%22 " 
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
    if ServList = 5     ; si le choix dans la liste est Dropbox
    {
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22dl.dropbox.com/%22 " 
        Run %GoogleRequest%
        Return
    }
    if ServList = 5     ; si le choix dans la liste est dl.free.fr
    {
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22dl.free.fr/%22 " 
        Run %GoogleRequest%
        Return
    }
    if ServList = 5     ; si le choix dans la liste est Anyhub
    {
        GoogleRequest := "http://www.google.fr/search?hl=fr&q=" . SearchText . " %22anyhub.net/file/%22 " 
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



; http://anyhub.net/file/ch%C3%A8que-editor-4.01.rar







