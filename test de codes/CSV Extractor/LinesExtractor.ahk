Version = r1
NomDuScript =  LineExtractor  %Version%


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Nom :			    LineExtractor
; Language:       	Français
; Platform:         WinXP
; Auteur:           IrisSoft
; AutoHotkey     	Version: 1.0.47
; Version :		    Alpha rrelease 1
; Lissence		    GPL ou LGPL (pas encore choisit mais en tout cas il sera en lissence libre)
; Description :	    permet de mettre chacques lignes d'un fichier dans des variables séparées puis de les insérer dans une listbox
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoTrayIcon

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; met dans la variable le nom du fichier
FileName = initiation.txt

; extrait les lignes du fichier et renvoie leur nombre
LineNumber := ExtractLine(Filename)

; met dans la variable ListItems les lignes précédament récupéré
ListItems := GetLinesInList()

   ;initialiser la fenêtre avec le texte et la liste
   Gui, Font, S12 CDefault, Arial							  ; Choix de la police d'affichage du logiciel et de sa taille
   Gui, Add, Text, x6 y10 w150 h20, Choisissez une leçon` :  
   Gui, Add, ListBox, vChoice w500 h300 hscroll vscroll, %ListItems%

   ; affiche la fenêtre programmé
   Gui, Show,,   %NomDuScript% - Tutoriel Informatique



; quite le programme
ExitApp  

 
; création de la fonction qui extrait chaques lignes d'un fichier
ExtractLine(FileName)
{
	; Mettre le contenu du fichier dans une variable temporaire
	Loop, Read, %FileName%
	{
 		Line%A_Index% := %A_Index% + " - " + %A_LoopReadLine%
		StringTrimRight, Line%A_Index%, Line%A_Index%, 1
		LineNumber = %A_Index%
	}
	Return, %LineNumber%
}  	

; fonction d'extraction des éléments du tableau pour créer une zone de liste avec
GetLinesInList() 
{
	; extraction du tableau des lignes pour créer une variable du contenu de la zone de liste
	loop %LineNumber%	; fait un loop jusqu'à la dernière ligne du fichier
	{
		ListItems := line%A_Index%	; on met le premier élément du tableau dans la variable list qui sera les données de la zone de liste
		if %A_Index% = 1				; si c'est la première ligne
			ListItems = list + " || "	; on ajoute deux bare verticale pour sélectioner le premier item de la liste
		else						; si c'est pas la première ligne
			ListItems = list + " | "	; on ajoute une bare verticale pour séparer les items de la liste
	}
	StringTrimRight, ListItems, ListItems, 2	; on enlève la barre verticale de la fin qui ne sert a rien
	
	; renvoie de la variable qui contient les éléments de la zone de liste
	Return, %ListItems%
}










