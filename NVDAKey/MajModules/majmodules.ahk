#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; déclaration des variables
IniVersion=version.ini


; routine principale du programme
Gosub,VersionRead
Sleep,300
GoSub,DlMajIni 
Sleep,300
GoSub,DisplayVersionResult
Sleep,300
Gosub,MajRead
Sleep,300
Gosub,DisplayMajResult
Sleep,300
GoSub,DownloadMaj
Gosub QuitApp





;----------------------------------------------------
;
; Sub du programme
;
;-------------------------------------------------------



VersionRead:
    IfExist, %IniVersion%
    {
          IniRead GetMajIni, %IniVersion%, update, MajIni, False			; lis et met dans la variable GetMajIni le lien de téléchargement du fichier ini de mise à jour
          IniRead GetMajUrl, %IniVersion%, update, MajUrl, False			; lis et met dans la variable GetMajIni le lien de téléchargement du fichier ini de mise à jour
          IniRead GetMajPath, %IniVersion%, update, MajPath, False		; lis et met dans la variable GetMajIni le lien de téléchargement du fichier ini de mise à jour
	
          IniRead GetAudacityRun, %IniVersion%, audacity, run, False		; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity
          IniRead GetAudacityVersion, %IniVersion%, audacity, Version, False	; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity
          IniRead GetWordRun, %IniVersion%, word, run, False			; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity
          IniRead GetWordVersion, %IniVersion%, word, Version, False		; lis et met dans la variable GetWordVersion le numéro courrent de la version de l'extenssion pour word

    }
    else		; si le fichier ini n'a pas été trouvé
    {
          MsgBox, Le fichier %IniVersion% est introuvable le programme vas s'arrêter	; affiche un message 
          Gosub QuitApp							; lance la sub qui quitte le programme
    }

Return

DlMajIni:
     UrlDownloadToFile, %GetMajUrl%%GetMajIni%, %GetMajIni%

Return

MajRead:

    IfExist, %GetMajIni%
    {
          IniRead GetAudacityCurrentVersion, %GetMajIni%, audacity, Version, False	; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity
          IniRead GetAudacityDlFile, %GetMajIni%, audacity, DlFile, False		; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity        
          IniRead GetWordCurrentVersion, %GetMajIni%, word, Version, False		; lis et met dans la variable GetWordVersion le numéro courrent de la version de l'extenssion pour word
          IniRead GetWordMajDlFile, %GetMajIni%, word, DlFile, False			; lis et met dans la variable GetWordVersion le numéro courrent de la version de l'extenssion pour word
    }
    else		; si le fichier ini n'a pas été trouvé
    {
          MsgBox, Le fichier %GetMajIni% est introuvable la mise a jour est impossible	; affiche un message 
          Gosub QuitApp							; lance la sub qui quitte le programme
    }

Return


DisplayVersionResult:
     Msgbox, Le nom du fichier ini de mise à jour est : %GetMajIni%
     Msgbox, l'adresse du dossier contenant les modules est : %GetMajUrl%
     Msgbox, Le chemin du dossier contenant les modules est : %GetMajPath%
     Msgbox, La version de l'extenssion actuelle d'audacity est : %GetAudacityVersion%
     Msgbox, La version de l'extenssion actuelle de word est : %GetWordVersion%

     ; vériffication de l'existance fi fichier ini de mise à jour
     IfExist, %GetMajIni%
     {
          Msgbox, Le fichier %GetMajIni% Existe bien
     }
     else		; si le fichier ini n'a pas été trouvé
     {
          MsgBox, Le fichier %GetMajIni% est introuvable 
          Gosub QuitApp							; lance la sub qui quitte le programme
     }
 
Return

DisplayMajResult:

     Msgbox, La version courrante  de l'extenssion d'audacity est : %GetAudacityCurrentVersion%
     Msgbox, Le nom du fichier de la mise à jour pour l'extenssion d'Audacity est : %GetAudacityDlFile%
     Msgbox, La version courrante  de l'extenssion de word est : %GetWordCurrentVersion%
     Msgbox, Le nom du fichier de mise à jour pour l'extenssion de word est : %GetWordMajDlFile%

Return

DownloadMaj:
     UrlDownloadToFile, %GetMajUrl%%GetWordMajDlFile%, %GetMajPath%%GetWordMajDlFile%

     ; vériffication de l'existance du fichier de l'extenession à mette à jour
     IfExist, %GetMajPath%%GetWordMajDlFile%
     {
          GoSub,RunMaj
     }
     else		; si le fichier ini n'a pas été trouvé
     {
          MsgBox, Le fichier de mise à jour de l'extenssion %GetWordMajDlFile% est introuvable
     }
Return


;--------------------------------------------------------------------------------------

RunMaj:

     IfExist, %GetMajPath%%GetWordMajDlFile%
     {
          Run %GetMajPath%%GetWordMajDlFile%
          GoSub,DelOldVersion
     }
     else		; si le fichier ini n'a pas été trouvé
     {
          MsgBox, Le fichier de mise à jour de l'extenssion %GetWordMajDlFile% est introuvable
     }

Return

;-------------------------------------------------------

DelOldVersion:
 
     FileDelete, %GetMajPath%%GetWordRun%
     FileDelete, %GetMajIni%
     Gosub QuitApp							; lance la sub qui quitte le programme
Return

;--------------------------------------------

QuitApp:
        ExitApp	; quitte le programme

