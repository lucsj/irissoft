#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; déclaration des variables
IniVersion=version.ini
MajIni=maj.ini
DownloadPath=addons\

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
        IniRead GetAudacityVersion, %IniVersion%, audacity, Version, False	; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity
        IniRead GetWordVersion, %IniVersion%, word, Version, False		; lis et met dans la variable GetWordVersion le numéro courrent de la version de l'extenssion pour word

    }
    else		; si le fichier ini n'a pas été trouvé
    {
        MsgBox, Le fichier %IniVersion% est introuvable le programme vas s'arrêter	; affiche un message 
        Gosub QuitApp							; lance la sub qui quitte le programme
    }

Return

DlMajIni:
     UrlDownloadToFile, %GetMajIni%, %MajIni%

Return

MajRead:

    IfExist, %MajIni%
    {
          IniRead GetAudacityCurrentVersion, %MajIni%, audacity, Version, False	; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity
          IniRead GetAudacityMajUrl, %MajIni%, audacity, DlUrl, False		; lis et met dans la variable GetAudacityVersion  le numéro courrent de la version de l''extenssion pour audacity        
          IniRead GetWordCurrentVersion, %MajIni%, word, Version, False		; lis et met dans la variable GetWordVersion le numéro courrent de la version de l'extenssion pour word
          IniRead GetWordMajUrl, %MajIni%, word, DlUrl, False			; lis et met dans la variable GetWordVersion le numéro courrent de la version de l'extenssion pour word
    }
    else		; si le fichier ini n'a pas été trouvé
    {
          MsgBox, Le fichier %MajIni% est introuvable la mise a jour est impossible	; affiche un message 

    }

Return


DisplayVersionResult:
     Msgbox, L'url du fichier ini de mise à jour est : %GetMajIni%
     Msgbox, La version de l'extenssion actuelle d'audacity est : %GetAudacityVersion%
     Msgbox, La version de l'extenssion actuelle de word est : %GetWordVersion%

     ; vériffication de l'existance fi fichier ini de mise à jour
     IfExist, %MajIni%
     {
          Msgbox, Le fichier %MajIni% Existe bien
     }
     else		; si le fichier ini n'a pas été trouvé
     {
          MsgBox, Le fichier %MajIni% est introuvable 
     }
 
Return

DisplayMajResult:

     Msgbox, La version courrante  de l'extenssion d'audacity est : %GetAudacityCurrentVersion%
     Msgbox, L'adresse de la mise à jour pour l'extenssion d'Audacity est : %GetAudacityMajUrl%
     Msgbox, La version de l'extenssion actuelle de word est : %GetWordCurrentVersion%
     Msgbox, L'adresse de la mise à jour pour l'extenssion de word est : %GetWordMajUrl%

Return

DownloadMaj:
     UrlDownloadToFile, %GetWordMajUrl%, %DownloadPath%word 3.1.nvda-addon

     ; vériffication de l'existance fi fichier ini de mise à jour
     IfExist, %DownloadPath%word 3.1.nvda-addon
     {
          Msgbox, le téléchargement de la mise à jour de word est réussit 
     }
     else		; si le fichier ini n'a pas été trouvé
     {
          MsgBox, Le fichier de la mise à jour de Word est introuvable 
     }
Return


QuitApp:
        ExitApp	; quitte le programme

