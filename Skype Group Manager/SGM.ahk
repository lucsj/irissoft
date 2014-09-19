Version = 0.5
NomDuScript =  Skype Groups Manager  %Version%


;----------------------------------------------------------------------------------------------------------------------------------------
; Nom :				Skype Groups Manager
; Language:       	Français
; Platform:             WinXP, vista, Seven
; Auteurs:              Luc S, 
; AutoHotkey     	Version: 1.0.47
; Version :			Alpha rrelease 10
; Description :		Menu des principales commande de skype pour la gestion de groupes dans le chat
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;
;
;---------------------------------------------------------------------------------

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; section protection du programme 
k0 = 0x11111111                  ; 128-bit secret key (example)
k1 = 0x22222222
k2 = 0x33333333
k3 = 0x44444444

l0 = 0x12345678                  ; 64- bit 2nd secret key (example)
l1 = 0x12345678

m0 = 0x87654321                  ; 64- bit 3rd secret key (example)
m1 = 0x87654321

IniFile = SafeSW.ini

GoSub    CheckAuth
SetTimer CheckAuth,1000
MsgBox,,,Ce logiciel est enregistré pour`n%User% at %Email%,4


; lis les valeurs dans le fichier ini et les met dans des variables ou des tableaux
Gosub GetFromIniFile

; création du menu dans la zone de notiffication
Menu,Tray,Tip,%WinTitle%
Menu,Tray,NoStandard
Menu,Tray,Icon,3d_skype.ico
Menu,Tray,DeleteAll
Menu,Tray,Add,Liste des &Commandes`t AltGR+Espace,ShowList
Menu,Tray,Add,&Définir les rôles`t AltGR+R,ShowRole
Menu,Tray,Add,Définir les &options`t Alt+Ctrl+O,ShowOptions
Menu,Tray,Add,
Menu,Tray,Add,&A Propos,About
Menu,Tray,Add,
Menu,Tray,Add,&Quitter`t Windows+F4,GuiClose

;initialiser la fenêtre avec le texte et la liste
Gui, 1:Font, S11 CDefault, Arial		; Choix de la police d'affichage du logiciel et de sa taille
Gui, 1:Color, 51D5FF
Gui, 1:Add, Text, x20 y4 w250 h20, Choisissez une action :
Gui, 1:Add, ListBox, vchoix gDbleClick x20 y30 w550 h330 c1D781D vscroll AltSubmit, %items%
Gui, 1:Add, Button, vSend gValide x585 y120 w100 h40 cEFF000 +Default, &Valider
Gui, 1:Add, Button, vCancel gclose x585 y220 w100 h40 ceff000, &Annuler


;initialiser la fenêtre permettant de définir un rôle aux membres de la conversation
Gui, 2:Font, S11 CDefault, Arial		; Choix de la police d'affichage du logiciel et de sa taille
Gui, 2:Color, 51D5FF
Gui, 2:Add, Text, x20 y4 w300 h20, Entrez un pseudo et choisissez son rôle
Gui, 2:Add, Text, x20 y40 w110 h20, Pseudo skype :
Gui, 2:Add, Edit, vPseudo x135 y40 w150 h20
Gui, 2:Add, Text, x20 y80 w200 h20, Choisissez le rôle :
Gui, 2:Add, ListBox, vRole gDbleClick x20 y110 w120 h110 vscroll , Creator||Master|Helper|User|Listener|Applicant
Gui, 2:Add, Button, vSendRole gValideRole x160 y110 w120 h40 +Default, &Définir ce rôlle
Gui, 2:Add, Button, vCancelRole gCloseRole x160 y162 w120 h40, &Annuler

;Innitialiser la fenêtre des options d'un groupe 
Gui, 3:Font, S12 CDefault, Arial		; Choix de la police d'affichage du logiciel et de sa taille
Gui, 3:Color, 51D5FF
Gui, 3:Add,Text, x20 y4 w300 h20, Choisissez les options du groupe et son mot de passe
Gui, 3:Add, Radio, vJoinApliquant x20 y40 w450 h20, Nécessite une autorisation pour être ajouté
Gui, 3:Add, Radio, vJoinListener x20 y70 w450 h20, Il faut être utilisateurs pour pouvoir  participer au groupe
Gui, 3:Add, Radio, vJoinEnabled x20 y100 w450 h20, Les nouveaux utilisateurs peuvent rejoindre la discussion.
Gui, 3:Add, Checkbox, vShowHistory x20 y150 w450 h20, Afficher l'historique du groupe
Gui, 3:Add, Checkbox, vTopicLocked x20 y175 w450 h40, Empêche les utilisateurs de changer l'image et le thème du groupe
Gui, 3:Add, Checkbox, vUserListener x20 y220 w450 h40, Les utilisateurs ne peuvent pas écrire, seulement les créateurs le peuvent
Gui, 3:Add, Checkbox, vAddPassword x20 y265 w450 h20, Ajouter un mot de passe au groupe
Gui, 3:Add, Text, x20 y295 w110 h20, Mot de passe :
Gui, 3:Add, Edit, vPassword x135 y295 w150 h20
Gui, 3:Add, Button, vSendOptions gValideOptions x20 y330 w160 h40 +Default, &Définir les options
Gui, 3:Add, Button, vCancelOptions gCloseOptions x260 y330 w120 h40, &Annuler

return


;------------------------------------------------------------------------------------------------
;
; Racourcis clavier
;
;------------------------------------------------------------------------------------------------

; Afficher la liste des commandes en appuyant sur Alt+Espace

^!Space::
   Gosub ShowList
return

;---------------------------------------------------------------------------------------

; afficher le choix d'un rôle pour un pseudo en appuyant sur altgr plus r

^!r::
   Gosub ShowRole
return

;------------------------------------------------------------------------------------
-----

; Affiche la fenêtre des options en appuyant sur Ctrl+Alt+O

^!o::
   Gosub ShowOptions
return

;------------------------------------------------------------------------------------------------------------

; Quitter en appuyant sur Windows+f4

#F4::
   Gosub GuiClose
return 

;---------------------------------------------------------------------------------------------


#IfWinActive ahk_class AutoHotkeyGUI		; Active les racourcis clavier uniquement si la fenêtre du programme est active
   ;la touche échap a pour effet de Fermer la liste des commandes
   Escape::
        Gosub close
   return
#IfWinActive



;---------------------------------------------------------------------------------
;
;  Fonctions
;
;-----------------------------------------------------------------------------

; lis les valeurs dans le fichier ini et les met dans des variables ou des tableaux

GetFromIniFile:
		TabCount = 1
		; Le fichier .ini doit avoir le même nom que le programme
    	; ce qui permet de copier le programme sous des noms différents
    	; avec des .ini différents
    	SplitPath, A_ScriptName,,,, ScriptNoExt
    	ScriptIni = %ScriptNoExt%.ini
    	; vérification de l'existance du fichier ini
    	IfExist, %ScriptIni%
    	{
			IniRead WinTitle, %ScriptIni%, options, Titre, False 	;lit le titre de la fenêtre
			; lis le nom des programme et les met dans un tableau
			loop
			{
				IniRead CmdName, %ScriptIni%, cmd%TabCount%, CmdName, False 		;lit le nom de la commande
				IniRead CmdKey, %ScriptIni%, cmd%TabCount%, CmdKey, False		;lis le racourcis clavier à lancer
				IniRead CmdType, %ScriptIni%, cmd%TabCount%, CmdType, False		;lis le type de la commande
				CmdNameItems%TabCount% := CmdName		; Ajoute le nom de la commande dans un tableau
				CmdKeyItems%TabCount% := CmdKey			; Ajoute le racourcis à un tableau
				CmdTypeItems%TabCount% := CmdType			; Ajoute le tupe de la commande à un tableau
				if CmdName = False				; si on arrive a la fin du fichier ini les variables sont remplit avec false,
				{
					break				; on sort de la boucle loop
				} 
			TabCount +=1
			}
		}
    	else
    	{
        	MsgBox, Le fichier %ScriptIni% est introuvable le programme vas s'arrêter
        	Gosub GuiClose     
    	}
		Gosub MakeCmdList
return

;--------------------------------------------------------------------------------------------------


; Créé la liste des commandes 


MakeCmdList:

	MenuCount = 1
	Loop		; boucle sans fin se termine uniquement quand il n'y a plu de menus
	{
	    	; on vas chercher les commande et leur racourcis dans le tableau créé précédament
	    	CmdName := CmdNameItems%MenuCount%		
	    	if CmdName = False						; si on arrive a la fin des menus les variables sont remplit avec false,
	    	{
        		break			; On est arrivé a la fin de la liste des menus, donc on sort de la boucle
	    	}
	    	if MenuCount = 1						; si c'est la première fois qu'on ajoute un élément a  la liste
	    	{
	        	items = %CmdName%||			; ajouter le nom du menu qu'on atrouvé dans le fichier ini
	    	}
 	    	else	; sinon dans tous les autres cas
	    	{
				items = %items%%CmdName%|			; on concatenne la liste avec les nouveaux éléments trouvés dans le fichier ini
	    	}
			;LV_Add("", CmdName, CmdStringKey)
			MenuCount +=1	; on incrémente le compteur d'application
	}
	;LV_ModifyCol()
Return

;--------------------------------------------------------------------------------

; Affiche la liste des commandes des groupes de skype


ShowList:
	Gui, 1:Show, w700 h400, %Wintitle%
return


;---------------------------------------------


; valide l'une des fonctions de la liste et l'exécute

valide:
		Gui, 1:Submit
		GuiControlGet, choix   		        	; Renvoie le choix fait par l'utilisateur
		Key := CmdKeyItems%choix%              ; met dans la variable Key le racourcis clavier corespondant
		Type := CmdTypeItems%choix% 		   ; met dans la variable type le type de la commande
		if Type = single							; si le type de la commande est simple on l'envoie directement sans paramètres
		{
			Send %Key% {enter}						; envoie la commande qui est dans la variable key et appuy sur entré
		}
		else if Type = text							; si le type corresponds à un texte à entrer 
		{
			; une boîte de dialogue s'affiche pour nous permettre d'entrer le texte
			InputBox, Texte, Entrez le texte pour compléter l'action choisit
			if ErrorLevel <> 0							; si l'utilisateur a annulé on sort de la fonction
			{
					MsgBox, Annulation !
					Return
			}              	
			else										; si l'utilisateur a cliqué sur le bouton  OK
			{
				Send %Key% %Texte% {enter}						; envoie la commande qui est dans la variable key plus son texte, et valide
			}
		}
            else if Type = pseudo							; si le type corresponds à un pseudo skype à entrer 
		{
			; une boîte de dialogue s'affiche pour nous permettre d'entrer le texte
			InputBox, Texte, Entrez le pseudo skype  pour compléter l'action choisit
			if ErrorLevel <> 0							; si l'utilisateur a annulé on sort de la fonction
			{
					MsgBox, Annulation !
					Return
			}              	
			else										; si l'utilisateur a cliqué sur le bouton  OK
			{
				Send %Key% %Texte% {enter}						; envoie la commande qui est dans la variable key plus son texte, et valide
			}
		}		
return

; fonction qui permet d'utiliser le double click pour valider le choix d'un item des listes

DbleClick:
	IfNotEqual A_GuiControlEvent,DoubleClick 		; si c'est bien un doubleclick car un simple click active aussi la fonction
	{
		Return
	}
	else
	{
		gosub Valide

	}
return


;-----------------------------------------------------------------------------------

; cache la fenètre de la liste des commandes

close:

   Gui 1:cancel
   GuiEscape:

return

;--------------------------------------------------------------------------------------------

; affiche la fenêtre d'affectation des rôles

ShowRole:

   	Gui, 2:Show, w310 h240, Définition d'un rôle

return
;---------------------------------------------------------------------

; valide l'affectation d'un rôle 

ValideRole:

		Gui, 2:Submit
		Send /setrole %Pseudo% %Role% {enter}					; envoie la commande role et le contenu du pseudo et de son rôle

            ; réinitialisation du contenu des champs
            GuiControl, 2: , Pseudo, 
            GuiControl, 2: , Role, 
return

;---------------------------------------------------------------------------

; annule la définition d'un rôle

CloseRole:

   Gui 2:cancel

return

;--------------------------------------------------------------------------------

; affiche la boîte de dialogue de définition des options d'un gorupe

ShowOptions:

   	Gui, 3:Show, w500 h400, Définition des options d'un groupe

return

;-------------------------------------------------------------------------------

; Valide les options

ValideOptions:

		Gui, 3:Submit
            if AddPassword=1         ; si la case définir un mot de passe a été coché
            {      
		      if (Password="")      ; si le champ mot de passe est vide
		      {
		            Msgbox, Vous avez oublié d'entrer le mot de passe    ; on affiche une boîte qui informe de l'erreur
		            return      ; on sort de la fonction
		      }
                  else
                  {
		            Send /set password %Password% {enter}				; envoie la commande mot de passe  et son contenu                        
                  }   
            }
            Sleep 300
            if ShowHistory=1
            {
		            Send /set options HISTORY_DISCLOSED {enter}				; envoie la commande pour activer l'historique de du groupe
            }
            Sleep 300
            if TopicLocked=1
            {
		            Send /set options TOPIC_AND_PIC_LOCKED_FOR_USERS {enter}				; envoie la commande pour activer la protection du titre du groupe et de son image
            }
            Sleep 300
            if UserListener=1
            {
		            Send /set options USERS_ARE_LISTENERS {enter}				; envoie la commande pour empêcehr les participants à écrire dans le groupe 
            }

            if JoinEnabled=1
            {
		            Send /set options JOINING_ENABLED {enter}				; envoie la commande qui permet que les nouveaux utilisateurs uisse s'ajouter au groupe
            }                          
            else if JoinListener=1
            {
		            Send /set options JOINERS_BECOME_LISTENERS {enter}				; envoie la commande qui permet que les nouveaux utilisateurs ne peuvent envoyer des messages que si ils ont été définis comme utilisateur
            }
            else if JoinApliquant=1
            {
                        Send /set options JOINERS_BECOME_APPLICANTS {enter}				; envoie la commande qui permet que les nouveaux utilisateurs ne peuvent envoyer des messages que si ils ont été ajoutés                        
            }
                        
                                                    
             ;remettre à zéro les options
             GuiControl,,Password,
             GuiControl,,AddPassword,0
             GuiControl,,ShowHistory,0 
             GuiControl,,TopicLocked,0 
             GuiControl,,UserListener,0 
             GuiControl,,JoinEnabled,0
             GuiControl,,JoinListener,0 
             GuiControl,,JoinApliquant,0 
return

;------------------------------------------------------------------------------

; annule la saisie d'options

CloseOptions:

   Gui 3:cancel

return

;---------------------------------------------------------------------------
;
;              fonctions pour la protection du programme
;
;---------------------------------------------------------------------------------

;  HASH by Laszlo Hars <www.Hars.US> 

HASH(ByRef sData, nLen, SID = 3) { ; SID = 3: MD5, 4: SHA1
   DllCall("advapi32\CryptAcquireContextA", UIntP,hProv, UInt,0, UInt,0, UInt,1, UInt,0xF0000000)
   DllCall("advapi32\CryptCreateHash", UInt,hProv, UInt,0x8000|0|SID, UInt,0, UInt,0, UIntP, hHash)

   DllCall("advapi32\CryptHashData", UInt,hHash, UInt,&sData, UInt,nLen, UInt,0)

   DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,0, UIntP,nSize, UInt,0)
   VarSetCapacity(HashVal, nSize, 0)
   DllCall("advapi32\CryptGetHashParam", UInt,hHash, UInt,2, UInt,&HashVal, UIntP,nSize, UInt,0)

   DllCall("advapi32\CryptDestroyHash", UInt,hHash)
   DllCall("advapi32\CryptReleaseContext", UInt,hProv, UInt,0)

   IFormat := A_FormatInteger
   SetFormat Integer, H
   Loop %nSize%
      sHash .= SubStr(*(&HashVal+A_Index-1)+0x100,-1)
   SetFormat Integer, %IFormat%
   Return sHash
}


;---- End autoexecute secsion ----;

CheckAuth:
   IniRead User, %IniFile%, Registration, User
   IniRead Email,%IniFile%, Registration, Email
   IniRead Code, %IniFile%, Registration, UnlockCode
   PCdata = %COMPUTERNAME%%HOMEPATH%%USERNAME%%PROCESSOR_ARCHITECTURE%%PROCESSOR_IDENTIFIER%
   PCdata = %PCdata%%PROCESSOR_LEVEL%%PROCESSOR_REVISION%%A_OSType%%A_OSVersion%%Language%
   Fingerprint := XCBC(Hex(PCdata,StrLen(PCdata)), 0,0, 0,0,0,0, 1,1, 2,2)
   Together = %User%%Email%%Fingerprint%
   AuthData := XCBC(Hex(Together,StrLen(Together)), 0,0, k0,k1,k2,k3, l0,l1, m0,m1)
   If (User="Error" || Email="Error" || Code <> AuthData)
   {
      S = %Fingerprint%
      ClipBoard = %S%
      MsgBox S'il vous plait Enregistrez-vous! remplissez le formulaire qui vas s'ouvrir, et collez-y le numéro de votre ordinateur, celui-ci servira à générer votre lissence.
      MsgBox veuillez remplir corectement le formulaire d'enregistrement
      Run, http://www.logiciels-en-video.com/blog-logiciels/enregistrement-sgm/
      ExitApp
   }
Return

;---- Crypto functions ----;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TEA cipher ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Block encryption with the TEA cipher
; [y,z] = 64-bit I/0 block
; [k0,k1,k2,k3] = 128-bit key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TEA(ByRef y,ByRef z, k0,k1,k2,k3)
{                                   ; need  SetFormat Integer, D
   s = 0
   d = 0x9E3779B9
   Loop 32                          ; could be reduced to 8 for speed
   {
      k := "k" . s & 3              ; indexing the key
      y := 0xFFFFFFFF & (y + ((z << 4 ^ z >> 5) + z  ^  s + %k%))
      s := 0xFFFFFFFF & (s + d)  ; simulate 32 bit operations
      k := "k" . s >> 11 & 3
      z := 0xFFFFFFFF & (z + ((y << 4 ^ y >> 5) + y  ^  s + %k%))
   }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; XCBC-MAC ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; x  = long hex string input
; [u,v] = 64-bit initial value (0,0)
; [k0,k1,k2,k3] = 128-bit key
; [l0,l1] = 64-bit key for not padded last block
; [m0,m1] = 64-bit key for padded last block
; Return 16 hex digits (64 bits) digest
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

XCBC(x, u,v, k0,k1,k2,k3, l0,l1, m0,m1)
{
   Loop % Ceil(StrLen(x)/16)-1   ; full length intermediate message blocks
      XCBCstep(u, v, x, k0,k1,k2,k3)

   If (StrLen(x) = 16)              ; full length last message block
   {
      u := u ^ l0                   ; l-key modifies last state
      v := v ^ l1
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Else {                           ; padded last message block
      u := u ^ m0                   ; m-key modifies last state
      v := v ^ m1
      x = %x%100000000000000
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Return Hex8(u) . Hex8(v)         ; 16 hex digits returned
}

XCBCstep(ByRef u, ByRef v, ByRef x, k0,k1,k2,k3)
{
   StringLeft  p, x, 8              ; Msg blocks
   StringMid   q, x, 9, 8
   StringTrimLeft x, x, 16
   p = 0x%p%
   q = 0x%q%
   u := u ^ p
   v := v ^ q
   TEA(u,v,k0,k1,k2,k3)
}

Hex8(i)                             ; 32-bit integer -> 8 hex digits
{
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex
   i += 0x100000000                 ; convert to hex, set MS bit
   StringTrimLeft i, i, 3           ; remove leading 0x1
   SetFormat Integer, %format%      ; restore original format
   Return i
}

Hex(ByRef b, n=0)                   ; n bytes data -> stream of 2-digit hex
{                                   ; n = 0: all (SetCapacity can be larger than used!)
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex           ; for converting bytes to hex

   m := VarSetCapacity(b)
   If (n < 1 or n > m)
       n := m
   Loop %n%
   {
      x := 256 + *(&b+A_Index-1)    ; get byte in hex, set 17th bit
      StringTrimLeft x, x, 3        ; remove 0x1
      h = %h%%x%
   }
   SetFormat Integer, %format%      ; restore original format
   Return h
}





















;------------------------------------------------------------------------------------------

; Affiche une boîte de dialogue à propos

About:
	MsgBox %NomDuScript% `n  `n Lissence GPL 3 `n Copywright (C) 2012 L. Segura
return

;---------------------------------------------------------------------

; Ferme le programme

GuiClose:
   ExitApp

















