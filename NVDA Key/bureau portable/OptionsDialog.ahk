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

#NoTrayIcon


; Créer le GUI principal avec une marge
  Gui, Margin, 5, 5

  ; Choix de la police d'affichage du logiciel et de sa taille
  Gui, Font, S12 CDefault, Arial

  Gui, Add, GroupBox, x40 y10 w400 h100, Titre de la fenêtre
  Gui, Add, Radio, vSetTitle x50 y35 w250 h20, Personnaliser le titre
  Gui, Add, Radio, x220 y35 w150 h20, Titre par défaut
  Gui, Add, Text,  vTxtTitle x80 y70 w170 h20, Titre :
  Gui, Add, Edit, vTitleWin x130 y70 w215 h20

  Gui, Add, GroupBox, x40 y140 w400 h80, Programme à démarrer 
  Gui, Add, Radio, vStartProgram x50 y165 w250 h20,  Démarrer un programmme 
  Gui, Add, Radio, x280 y165 w150 h20, Ne rien démarrer
  Gui, Add, Edit, vStartProgPath x80 y190 w220 h20, 
  Gui, Add, Button, gBrowsStartApp x315 y190 w100 h20, Parcourrir  

  Gui, Add, GroupBox, x40 y250 w400 h110, Programme à arrêter 
  Gui, Add, Radio, vStopProgram x50 y270 w250 h20, Arrêter un programmme 
  Gui, Add, Radio, x280 y270 w150 h20, Ne rien arrêter
  Gui, Add, Edit, vStopProgPath x80 y295 w220 h20, 
  Gui, Add, Button, gBrowsStopApp x315 y295 w100 h20, Parcourrir  
  Gui, Add, Text, x50 y323 w150 h20, Nom du programme :
  Gui, Add, Edit, vAppStartName x215 y320 w200 h20,

  Gui, Add, Button, gSave x80 y373 w120 h40, Enregistrer 
  Gui, Add, Button, gCancel x280 y373 w120 h40, Annuler

  Gosub GetOptions

  Gui, Show, w480 h440, Options

  return    
  
;----------------------------------------------------------------------------------------------------------------
;                            Subs de la boîte de dialogue Options
;----------------------------------------------------------------------------------------------------------------

; fonction qui vas chercher les options courrantes dans le fichier ini

GetOptions:
    ScriptIni = bureau_portable.ini
    IniRead WinTitle, %ScriptIni%, Fenetre, Titre, False 	;lit le titre de la fenêtre
    IniRead Start, %ScriptIni%, Fenetre, Start, False
    IniRead StartAppName, %ScriptIni%, Fenetre, StartAppName, False  : lis le nom de l'application que le bureau portable à démarré
    IniRead Stop, %ScriptIni%, Fenetre, Stop, False      ; lis la commande pour arrêter l'application précédament démarreé par le bureau portable
    if WinTitle <> False
    {
        GuiControl, 1: , TitleWin, %WinTitle%
        Guicontrol, 1: , SetTitle, 1
    }
    if Start <> False
    {
        GuiControl, 1: , StartProgPath, %Start%
        GuiControl, 1: , StartProgram,  1    
    }
    if StartAppName <> False
    {
        GuiControl, 1: , AppStartName, %StartAppName%  
    }
    if Stop <> False
    {
        GuiControl, 1: , StopProgPath, %Stop%
        GuiControl, 1: , StopProgram, 1
    }
return

;-----------------------------------------------------------------------------------------------------------

; Fonction qui enregistre les options

SetOptions:

return

; fonction qui active la boîte de dialogue de choix d'un programme

BrowsStartApp:
   FileSelectFile, ProgStartPath, 3, ,, Fichiers exécutables (*.exe)
   GuiControl, 1: , StartProgPath, %ProgStartPath%

return

;------------------------------------------------------------------------------------------------------------------
; choisit la ligne de comande pour arrêter l'application précédament démarré

BrowsStopApp:

return
;------------------------------------------------------------------------------------------------------------------

; fonction qui enregistre les changements des options dans le fichier ini
Save:

Return

;--------------------------------------------------------------------------------------------------------------------

; annule le changement des options

Cancel:

return

; exemple pour programmer un bouton qui déclanche un dialogue d'ouverture de fichier et affiche le chemin dans une zone d'édition
;Gui, Add, Edit, x16 y20 w300 h20 vselectedapp, ; gexecute, ; la bare affichant le chemin vers le paquet
;Gui, Add, Button, x326 y20 w30 h20 gopen, ...
;open:
;   FileSelectFile, appselected, 3, ,, Tous les fichiers (*.*)
;   GuiControl,, selectedapp, %appselected%
;return





