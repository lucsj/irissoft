Version = r10
ScriptName =  Recherche documents 
TitleWin1 = %ScriptName% - %Version%
TitleWin2 = Informations sur un document - %ScriptName%

;-----------------------------------------------------------------------------------------------------------------------------------
; Nom :				   Recherche documents
; Language:       	   Français
; Platform:            WinXP
; Auteurs:             Luc S, 
; AutoHotkey Version:  1.0.48.03
; Version :			   Alpha rrelease 10
; Lissence :		   GPL
; Description :		   Permet de rechercher et d'ouvrir un document scanné en entrant le numéro de son code barre qu'on peut scanner.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance,Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; lis dans le fichier ini le nom du fichier texte contenant les numéros et les noms des documents 
IniRead FileName, Recherche documents.ini, DocsInfo, DocsFile, False
; mettre dans une variable la valeur contenu dans le fichier ini
IniRead Dossier, Recherche documents.ini, DocsInfo, DocsPath, False


; Créer la fenêtre principal avec une marge
Gui, 1:Margin, 5, 5
; Choix de la police d'affichage du logiciel et de sa taille
Gui, 1:Font, S13 CDefault, Arial

; création d'un groupe ou groupbox en anglais
Gui, 1:Add, GroupBox, x60 y30 w300 h160, Identification ou ajout d'un document

; création d'un texte pour écrire la légende
Gui, 1:Add, Text, x80 y75 w110 h30, Rechercher :
; création d'un champ d'édition qui mettra son contenu dans la variable code
Gui, 1:Add, Edit, vCodeEnter x210 y70 w120 h30
; création d'un bouton qui déclanche la sub SearchOrAdd qui recherche ou ajoute un fichier si le code entré n'est pas dans la base
Gui, 1:Add, Button, gGoSearch x70 y125 w140 h40 +Default, &Cherche / Ajoute
; création d'un bouton pour quitter l'application
Gui, 1:Add, Button, gGuiClose x250 y125 w90 h40, &Quitter 

; création de la fnêtre de visualisation des  propriétées d'un fichier toujours avecv la même police et la même marge
Gui, 2:Margin, 5, 5
; Choix de la police d'affichage du logiciel et de sa taille
Gui, 2:Font, S12 CDefault, Arial
; ajout d'un texte qui indique qu'il s'agit des propriétées du document
Gui, 2:Add, Text, x10 y20 w250 h15, Informations sur le fichier :
; création de la liste déroulante qui contiendra le nom du documents et les renseignements sur ce document
Gui, 2:Add, ListBox, vChoice x10 y50 w620 h120
; création du bouton qui servira a valider et a fermer la fenêtre
Gui, 2:Add, Button, gRunDoc x265 y190 w100 h30 +Default, &Ouvrir

Gosub ShowMainWindows

Return

;----------------------------------------------------------------------------------
;
;           Fonctions du programme 
;
;----------------------------------------------------------------------------------

; fonction qui lance la recherche valide le nombre envoyé vide le chant et raffiche la fenêtre principale

GoSearch:
		Gui, 1:submit,   									 ; fait disparaitre la fenêtre et renvoie la valeur entré dans le champ
		Gosub SearchOrAdd									 ; Lance la recherche, appelle la fonction SearchOrAdd
		FindDocument = 										 ; vide la variable replaceword  qui contient le résultat de recherche
		ShowInfos = 										 ; vide la variable ShowInfo 
		GuiControl, 1: , CodeEnter, %FindDocument%		   	 ; vide le champ de recherche met a sa place la valeur de  FindDocument
		Gosub ShowMainWindows								 ; Réaffiche la fenêtre principale en appelantla fonction ShowMainWindow
Return




; fonction qui recherche la réfférence  d'un document  qui a été entré et qui si il ne la trouve pas l'ajoute

SearchOrAdd:
	; recherche du mot si il n'est pas trouvé une boîte de dialogue d'ajout sera affiché
    if (CodeEnter <> "" )											; si le champ d'édition n'est pas vide
    {
		IfExist, %FileName%											; si le fichier qui contient les éléments a rechercher existe
        {
			Loop, Read, %FileName%									; lis chaques lignes jusqu'a la fin du fichier
      	    {
					StringSplit, WordsArray, A_LoopReadLine, `=		; met dans un tableau le numéro le nom du fichier séparés par =
                    if (WordsArray1 = CodeEnter)					; si le code entré est le même que la première valeur du tableau
                    {
						FindDocument = %WordsArray2%					; on stoque dans une variable le nom de fichier corespondant
                    }
	        }
            if (FindDocument)										; si le document correspondant a été trouvé
            {
					Gosub ReadInfoToIniFile							; lis les propriétées du fichier ini et les met dans la liste
					Gosub ShowInfoWindow							; affiche la fenêtre d'information sur un document
					Loop
					{ 
						if ShowInfos = 1							; si on a cliqué sur le bouton voir fichier
						Break
					}	
			}     
            else													; si le code n'est pas répertorié
            {
                    ; le code n'a pas été trouvé, une boîte de dialogue s'ouvre pour nous demander si on veut l'ajouter
					MsgBox, 4, , Le code que vous avez entré est introuvable, s'agit-il d'un nouveau code ?
					IfMsgBox, No									; si le choix est non, on sort de la fonction
					{
						return
					}
					else										    ; si l'utilisateur a répondu oui 
					{
						; une boîte de dialogue s'affiche pour nous permettre d'entrer le nom du document
						InputBox, FindDocument, Entrez le nom du document correspondant au code entré
						if ErrorLevel <> 0							; si l'utilisateur a annulé on sort de la fonction
						{
							MsgBox, Annulation !
							Return
						}              	
						else										; si l'utilisateur a cliqué sur le bouton  OK
						{
							if (CodeEnter)							; on revérifie qu'un code a bien été entré  
							{
								Line = %CodeEnter%=%FindDocument%	; on met dans une variable la igne qui era ajouté au fichier
								FileAppend, `r`n%Line%,%FileName%	; on ajoute la ligne au fichier
								; uneboîte de dialogue rappelle le code et le nom de fichier qui ont été entré.
								MsgBox, le nouveau code %CodeEnter% a été ajouté, il réffère au document %Dossier%%FindDocument%   
							}
							else									; si aucun code n'a été entré
							{		
								; on affiche un message indiquant a l'utilisateur qu'il n'a pas entré de code
								MsgBox, Vous n'avez entré aucun code, l'ajout est annulé
							}
					} 					
				}	
            }
	    }
	    else														; si le fichier contenant les codes est introuvable
	    {
              MsgBox, le fichier %FileName% est introuvable			; onl'indique a l'utilisateur
        }
    }
    else															; si aucun code n'a été rentré
    {
        MsgBox, Vous n'avez entré aucun code						; on l'indique a l'utilisateur
    }
Return

;----------------------------------------------------------------------------

; cette fonction affiche la fenêtre principale du programme

ShowMainWindows:
		; affichage de la fenêtre principale
		Gui, 1:Show, w420 h240, %TitleWin1%

Return

;------------------------------------------------------------------------------------------

; fonction qui ouvre la fenêtre d'information sur un fichier

ShowInfoWindow:
		; Affiche la fenêtre d'information sur un document
		Gui, 2:Show, h240 w640, %TitleWin2%
Return


; fonction qui se déclanche en appuyant sur le bouton voir le document et qui lance l'ouverture du document correspondant au code

RunDoc:
		Gui, 2:submit,   									 ; fait disparaitre la fenêtre et renvoie la valeur entré dans le champ
		ShowInfos = 1
		Run, %Dossier%%FindDocument%							 ; on ouvre le document	
Return


; ------------------------------------------------------------------------------------------

; fonction qui vas chercher dans le fichier ini les informations sur un document et qui les insère dans la liste déroulante

ReadInfoToIniFile:

	InfoIniFile = %Dossier%%FindDocument%.ini				; on met dans la variable InfoIniFile le chemin et le nom du fichier ini
	IfExist, %InfoIniFile%
	{
				IniRead DateFile, %InfoIniFile%, Properties, Date, False
				IniRead DescribeFile, %InfoIniFile%, Properties, description, False
				IniRead LimitTime, %InfoIniFile%, Properties, Echeance, False
				if limittime = False
				{
					limittime = Aucune
				}
				IniRead LimitMsg, %InfoIniFile%, Properties, Rappel, False
				if LimitMsg = False
				{
					LimitMsg = Aucun
				}
				IniRead Category, %InfoIniFile%, Properties, Categori, False
	}	
	Else
	{
		MsgBox, Le fichier %InfoIniFile% n'existe pas, une erreur a du se produire pendant l'ajout du document.
	}	
	ListItems = |Nom du document :`t`t%FindDocument%||
	ListItems = %ListItems%Date du document :`t`t%DateFile%|
	ListItems = %ListItems%Description :`t`t%DescribeFile%|
	ListItems = %ListItems%Date de rappel :`t`t%LimitTime%|
	ListItems = %ListItems%Message de Rappel :`t%LimitMsg%|
	

	; affiché le contenu de la liste dans la fenêtre d'information d'un document
	GuiControl, 2: , Choice, %listitems%


Return


;--------------------------------------------------------------------------------------------

; quitte l'aplication

GuiClose:
   Gui cancel
   GuiEscape:
   ExitApp



