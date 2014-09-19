Version = r10
ScriptName =  Recherche documents 
TitleWin1 = %ScriptName% - %Version%
TitleWin2 = Informations sur un document - %ScriptName%

;-----------------------------------------------------------------------------------------------------------------------------------
; Nom :				   Recherche documents
; Language:       	   Fran�ais
; Platform:            WinXP
; Auteurs:             Luc S, 
; AutoHotkey Version:  1.0.48.03
; Version :			   Alpha rrelease 10
; Lissence :		   GPL
; Description :		   Permet de rechercher et d'ouvrir un document scann� en entrant le num�ro de son code barre qu'on peut scanner.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance,Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; lis dans le fichier ini le nom du fichier texte contenant les num�ros et les noms des documents 
IniRead FileName, Recherche documents.ini, DocsInfo, DocsFile, False
; mettre dans une variable la valeur contenu dans le fichier ini
IniRead Dossier, Recherche documents.ini, DocsInfo, DocsPath, False


; Cr�er la fen�tre principal avec une marge
Gui, 1:Margin, 5, 5
; Choix de la police d'affichage du logiciel et de sa taille
Gui, 1:Font, S13 CDefault, Arial

; cr�ation d'un groupe ou groupbox en anglais
Gui, 1:Add, GroupBox, x60 y30 w300 h160, Identification ou ajout d'un document

; cr�ation d'un texte pour �crire la l�gende
Gui, 1:Add, Text, x80 y75 w110 h30, Rechercher :
; cr�ation d'un champ d'�dition qui mettra son contenu dans la variable code
Gui, 1:Add, Edit, vCodeEnter x210 y70 w120 h30
; cr�ation d'un bouton qui d�clanche la sub SearchOrAdd qui recherche ou ajoute un fichier si le code entr� n'est pas dans la base
Gui, 1:Add, Button, gGoSearch x70 y125 w140 h40 +Default, &Cherche / Ajoute
; cr�ation d'un bouton pour quitter l'application
Gui, 1:Add, Button, gGuiClose x250 y125 w90 h40, &Quitter 

; cr�ation de la fn�tre de visualisation des  propri�t�es d'un fichier toujours avecv la m�me police et la m�me marge
Gui, 2:Margin, 5, 5
; Choix de la police d'affichage du logiciel et de sa taille
Gui, 2:Font, S12 CDefault, Arial
; ajout d'un texte qui indique qu'il s'agit des propri�t�es du document
Gui, 2:Add, Text, x10 y20 w250 h15, Informations sur le fichier :
; cr�ation de la liste d�roulante qui contiendra le nom du documents et les renseignements sur ce document
Gui, 2:Add, ListBox, vChoice x10 y50 w620 h120
; cr�ation du bouton qui servira a valider et a fermer la fen�tre
Gui, 2:Add, Button, gRunDoc x265 y190 w100 h30 +Default, &Ouvrir

Gosub ShowMainWindows

Return

;----------------------------------------------------------------------------------
;
;           Fonctions du programme 
;
;----------------------------------------------------------------------------------

; fonction qui lance la recherche valide le nombre envoy� vide le chant et raffiche la fen�tre principale

GoSearch:
		Gui, 1:submit,   									 ; fait disparaitre la fen�tre et renvoie la valeur entr� dans le champ
		Gosub SearchOrAdd									 ; Lance la recherche, appelle la fonction SearchOrAdd
		FindDocument = 										 ; vide la variable replaceword  qui contient le r�sultat de recherche
		ShowInfos = 										 ; vide la variable ShowInfo 
		GuiControl, 1: , CodeEnter, %FindDocument%		   	 ; vide le champ de recherche met a sa place la valeur de  FindDocument
		Gosub ShowMainWindows								 ; R�affiche la fen�tre principale en appelantla fonction ShowMainWindow
Return




; fonction qui recherche la r�ff�rence  d'un document  qui a �t� entr� et qui si il ne la trouve pas l'ajoute

SearchOrAdd:
	; recherche du mot si il n'est pas trouv� une bo�te de dialogue d'ajout sera affich�
    if (CodeEnter <> "" )											; si le champ d'�dition n'est pas vide
    {
		IfExist, %FileName%											; si le fichier qui contient les �l�ments a rechercher existe
        {
			Loop, Read, %FileName%									; lis chaques lignes jusqu'a la fin du fichier
      	    {
					StringSplit, WordsArray, A_LoopReadLine, `=		; met dans un tableau le num�ro le nom du fichier s�par�s par =
                    if (WordsArray1 = CodeEnter)					; si le code entr� est le m�me que la premi�re valeur du tableau
                    {
						FindDocument = %WordsArray2%					; on stoque dans une variable le nom de fichier corespondant
                    }
	        }
            if (FindDocument)										; si le document correspondant a �t� trouv�
            {
					Gosub ReadInfoToIniFile							; lis les propri�t�es du fichier ini et les met dans la liste
					Gosub ShowInfoWindow							; affiche la fen�tre d'information sur un document
					Loop
					{ 
						if ShowInfos = 1							; si on a cliqu� sur le bouton voir fichier
						Break
					}	
			}     
            else													; si le code n'est pas r�pertori�
            {
                    ; le code n'a pas �t� trouv�, une bo�te de dialogue s'ouvre pour nous demander si on veut l'ajouter
					MsgBox, 4, , Le code que vous avez entr� est introuvable, s'agit-il d'un nouveau code ?
					IfMsgBox, No									; si le choix est non, on sort de la fonction
					{
						return
					}
					else										    ; si l'utilisateur a r�pondu oui 
					{
						; une bo�te de dialogue s'affiche pour nous permettre d'entrer le nom du document
						InputBox, FindDocument, Entrez le nom du document correspondant au code entr�
						if ErrorLevel <> 0							; si l'utilisateur a annul� on sort de la fonction
						{
							MsgBox, Annulation !
							Return
						}              	
						else										; si l'utilisateur a cliqu� sur le bouton  OK
						{
							if (CodeEnter)							; on rev�rifie qu'un code a bien �t� entr�  
							{
								Line = %CodeEnter%=%FindDocument%	; on met dans une variable la igne qui era ajout� au fichier
								FileAppend, `r`n%Line%,%FileName%	; on ajoute la ligne au fichier
								; unebo�te de dialogue rappelle le code et le nom de fichier qui ont �t� entr�.
								MsgBox, le nouveau code %CodeEnter% a �t� ajout�, il r�ff�re au document %Dossier%%FindDocument%   
							}
							else									; si aucun code n'a �t� entr�
							{		
								; on affiche un message indiquant a l'utilisateur qu'il n'a pas entr� de code
								MsgBox, Vous n'avez entr� aucun code, l'ajout est annul�
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
    else															; si aucun code n'a �t� rentr�
    {
        MsgBox, Vous n'avez entr� aucun code						; on l'indique a l'utilisateur
    }
Return

;----------------------------------------------------------------------------

; cette fonction affiche la fen�tre principale du programme

ShowMainWindows:
		; affichage de la fen�tre principale
		Gui, 1:Show, w420 h240, %TitleWin1%

Return

;------------------------------------------------------------------------------------------

; fonction qui ouvre la fen�tre d'information sur un fichier

ShowInfoWindow:
		; Affiche la fen�tre d'information sur un document
		Gui, 2:Show, h240 w640, %TitleWin2%
Return


; fonction qui se d�clanche en appuyant sur le bouton voir le document et qui lance l'ouverture du document correspondant au code

RunDoc:
		Gui, 2:submit,   									 ; fait disparaitre la fen�tre et renvoie la valeur entr� dans le champ
		ShowInfos = 1
		Run, %Dossier%%FindDocument%							 ; on ouvre le document	
Return


; ------------------------------------------------------------------------------------------

; fonction qui vas chercher dans le fichier ini les informations sur un document et qui les ins�re dans la liste d�roulante

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
	

	; affich� le contenu de la liste dans la fen�tre d'information d'un document
	GuiControl, 2: , Choice, %listitems%


Return


;--------------------------------------------------------------------------------------------

; quitte l'aplication

GuiClose:
   Gui cancel
   GuiEscape:
   ExitApp



