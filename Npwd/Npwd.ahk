Version = 0.1
ScriptName =  Npwd
TitleWin1 = %ScriptName% - %Version%

;-----------------------------------------------------------------------------------------------------------------------------------
; Nom :				   Npwd
; Language:       	   Français
; Platform:            Win 7
; Auteurs:             Luc S, 
; AutoHotkey Version:  1.0.48.03
; Version :			   0.1
; Lissence :		   GPL 3
; Description :		   Permet de rechercher et de créer un mot de passe par site 


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; lis dans le fichier ini le nom du fichier texte contenant les adresse des sites et le fichier qui contient les paramètres de chacuns d'eux
IniRead FileName, Npwd.ini, PwdInfo, PwdFile, False
; mettre dans une variable le chemin d'accès du dossier contenant les informations pour calculer les mots de passe
IniRead Dossier, Npwd.ini, PwdInfo, PwdPath, False
; mettre dans une variable le mot principal à utiliser dans tous les mots de passe
IniRead Main, Npwd.ini, PwdInfo, MainWord, False


; création de la fenêtre principale

Gui, 1:Margin, 5, 5		; on créé une marge de 5 pixels
Gui, 1:Font, S12 CDefault, Arial		; affiche les caractères en  12 points avec la police arial

Gui, 1:Add, GroupBox, x40 y10 w400 h70, Recherche d'un mot de passe
Gui, 1:Add, Text, x50 y40 w110 h20, Recherche
Gui, 1:Add, Edit, vSite x150 y40 w150 h20, 
Gui, 1:Add, Button, gLoadSearch x320 y40  w80 h20, &Chercher 
Gui, 1:Add, GroupBox, x40 y100 w400 h70, Ajouter un mot de passe
Gui, 1:Add, Button, gNewPwd x130 y130 w210 h20, &Générer un mot de passe 
Gui, 1:Add, Button, gGuiClose x160 y190 w150 h30, &Quitter

Gosub ShowMainWindows

Return













;---------------------------------------------------------------------------------------------------------------------
;
;        Subs du programme
;
;---------------------------------------------------------------------------------------------------------


; fonction qui lance la recherche valide le nombre envoyé vide le chant et raffiche la fenêtre principale

LoadSearch:
		Gui, 1:submit,   									 ; fait disparaitre la fenêtre et renvoie la valeur entré dans le champ
		Gosub SearchPwd									 	 ; Lance la recherche, appelle la fonction SearchOrAdd
		FindPwd = 										 	  ; vide la variable qui contient le résultat de recherche
		ShowInfos = 										 ; vide la variable ShowInfo 
		GuiControl, 1: , Site, %FindPwd%		   	 ; vide le champ de recherche met a sa place la valeur de  FindDocument
		Gosub ShowMainWindows								 ; Réaffiche la fenêtre principale en appelantla fonction ShowMainWindow
Return


;----------------------------------------------------------------------------------



; Sub qui lance la recherche de mot de passe :

SearchPwd:

	; recherche du mot si il n'est pas trouvé une boîte de dialogue d'ajout sera affiché
    if (Site <> "")											; si le champ d'édition n'est pas vide
    {
		IfExist, %FileName%											; si le fichier qui contient les éléments a rechercher existe
        {
			Loop, Read, %FileName%									; lis chaques lignes jusqu'a la fin du fichier
      	    {
					StringSplit, WordsArray, A_LoopReadLine, `=		; met dans un tableau le numéro le nom du fichier séparés par =
					if WordsArray1 = %Site%
                    {
						FindPwdFile == %WordsArray2%					; on stoque dans une variable le nom de fichier corespondant
                    }
	        }
            if (FindPwdFile)										; si le document correspondant au site a été trouvé
            {
				; recherche des infos dans le fichier ini et affichage du pwd
				MsgBox, Affichage du mot de passe pour %site%
			}     
            else													; si le site n'est pas répertorié
            {
				MsgBox, Le site que vous avez entré n'est pas présent dans la base de donnée
            }
	    }
	    else														; si le fichier contenant les sites est introuvable
	    {
              MsgBox, le fichier %FileName% est introuvable			; onl'indique a l'utilisateur
        }
    }
    else															; si aucun code n'a été rentré
    {
        MsgBox, Vous n'avez entré aucune adresse de site						; on l'indique a l'utilisateur
    }
return

;----------------------------------------------------------------------------------------------------

; sub qui affiche la fenêtre principale

ShowMainWindows:

		; affichage de la fenêtre principale
		Gui, 1:Show, w500 h240, %TitleWin1%

Return

;------------------------------------------------------------------------------------------------------

; sub qui affiche le dialogue de génération d'un nouveau mot de passe

NewPwd:



Return



;--------------------------------------------------------------------------------------------

; quitte l'aplication

GuiClose:
   Gui cancel
   GuiEscape:
   ExitApp










