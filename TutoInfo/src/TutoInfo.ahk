Version = r10
NomDuScript =  TutoInfo  %Version%


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Nom :				TutoInfo		
; Language:       	Fran�ais
; Platform:         WinXP
; Auteur:           IrisSoft
; AutoHotkey     	Version: 1.0.47
; Version :			Alpha rrelease 10
; Lissence :		GPL ou LGPL (pas encore choisit mais en tout cas il sera en lissence libre)
; Description :	Ce programme permettra aux d�ficients visuels, de se former seul a l'informatique, ou a un proffesseur d'informatique ;				  de pouvoir enseigner plus efficacement a plusieurs �l�ves enm�me temps,  gr�ce a l'�coute de cours, aux QCM et  
;				aux exercices qui seront propos� les �l�ves progressivement acqu�rirons les conaissances requises, sans que leur 
;				professeur soie la tous le temps pour les aider, et pouront refaire les cours qu'ils ont �tudi�s 
;				tous seul chez eux pour se perfectioner
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoTrayIcon

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



;cr�ation d'une listebox avec le contenu de la variable items

   ; d�fini et affecte la variable items, qui remplira la zonne de liste
   items = 1 - les bases de l'informatique||2 - Windows le bureau explications|3 - Le bureau, le menu d�marrer et la barre des t�ches|4 - Ouvrir et fermer un programme|5 - Le menu d�marrer|6 - Word, exploration des menus|7 - Word, edition de texte

   ;initialiser la fen�tre avec le texte et la liste
   Gui, Font, S12 CDefault, Arial							  ; Choix de la police d'affichage du logiciel et de sa taille
   Gui, Add, Text, x6 y10 w150 h20, Choisissez une le�on` :  
   Gui, Add, ListBox, vChoice w500 h300 hscroll vscroll, %items%
   Gui, Add, Button, vSend gValide x110 y340 w60 h21 +Default, &Valider
   Gui, Add, Button, vCancel gGuiClose x260 y340 w60 h21, A&nnuler

   ; affiche la fen�tre programm�
   Gui, Show,,   %NomDuScript% - Tutoriel Informatique

   ;la touche �chap a pour effet de quitter im�diatement le programme
   Escape::
        Gosub GuiClose        
   return
return 

  
;--------------------------------------------------------------------------------------------
; Fonctions
;------------------------------------------------------------------------------------------


; cette fonction est lanc� quand on valide sur la liste, elle renvoie le choix dans la variable Choice
Valide:
   Gui, submit,   
   GuiControlGet, Choice                             ; Renvoie le choix fait par l'utilisateur
   Gosub, TestChoice
   msgBox,, Tuto informatique, Merci d'avoir utilis� TutoInfo`, `n`n  ce programme est encore en phase alpha de son d�veloppement`, `n et donc peut pr�senter quelques d�faillances ou erreurs de jeunesse`,  `n merci de v�tre patience.,
   Gosub, GuiClose
return  

;----------------------------------------------------------------------------

;teste quel item de laliste a �t� choisit par l'utilisateur
TestChoice:

     IfInString, Choice, 1, Gosub, Cours1	 
     IfInString, Choice, 2, Gosub, Cours2
     IfInString, Choice, 3, Gosub, Cours3
     IfInString, Choice, 4, Gosub, Cours4
     IfInString, Choice, 5, Gosub, Cours5
     IfInString, Choice, 6, Gosub, Cours6
     IfInString, Choice, 7, Gosub, Cours7

return

;-----------------------------------------------------------------------------------------------

;la premi�re le�on du tuto
Cours1:
	Cours1Line1 = Premi�re le�on `n `n
	Cours1Line2 = Dans ce cours vous d�couvrirez ce qu'est windows, a quoi il sert et ses principes de bases `n
	Cours1Line3 = Ainsi que ce qu'est un syst�me d'exploitation. `n`n
	Cours1Line4 = Pour commencer la le�on appuyez sur Entr� `n
	msgCours1 = %Cours1Line1% %Cours1Line2% %Cours1Line3% %Cours1Line4%

	msgBox,, Le�on 1,  %msgCours1%,
return

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; la fonction qui lance la le�on 2
Cours2:
	msgCours2 = Deuxi�me le�on `n`n Dans cette le�on vous apprendrez ce qu'est le bureau, comment y aller et comment choisir ubne ic�ne, `n Vous apprendrez aussi plusieurs solutions pour retrouver rapidement un programme et pour explorer le contenu du bureau. `n`n Pour commencer la le�on, appuyez su rentr�`n

	msgBox,, Le�on 2, %msgCours2%,

return

;---------------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la le�on 3

Cours3:
	MsgCours3 = Troisi�me le�on `n`n Dans cette le�on vous apprendrez ce qu'est la barre des t�ches le menu d�marrer, `n comment naviguer entre ces trois �l�ments a quoi ils servent `n et comment les utiliser. `n`n Pour commencer la le�on, appuyez sur entr� `n

	msgBox,, Le�on 3, %msgCours3%,
return


;-----------------------------------------------------------------------------------------------------
; la fonction qui lance la le�on 4

Cours4:
	msgCours4 = Quatri�me le�on, `n`n Dans cette le�on nous allons apprendre comment lancer et arr�ter un programme `n on vas apprendre aussi a cona�tre a quoi serve certains programmes etc... `n `n Pour commencer la le�on, appuyez sur entr�. `n

	msgBox,, Le�on 4, %msgCours4%,
return


;----------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la le�on 5

Cours5:
	msgCours5 = Cinqui�me le�on, `n `n Dans cette le�on vous apprendrez ce qu'est le menu d�marrer, `n comment l'utiliser, l'explorer et comment ouvrir un programme en l'utilisant `n Vous aprendrez ce qu'est un menu, ce qu'est un sous-menu `n et les touches de navigation a l'int�rieur des menus `n `n Pour commencer la le�on, appuyez sur Entr�.

	msgBox,, Le�on 5, %msgCours5%,
return


;-----------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la le�on 6

Cours6:
	msgCours6 = Sixi�me le�on, `n `n Dans cette le�on vous apprendrez ce qu'est Microsoft Word,  `n A quoi sert un traitement de texte, qu'est-ce que les menu d'un logiciel, comment les utiliser  `n Vous d�couvrirez les principaux menus de Word, et leur utilit�`n `n Pour commencer la le�on, appuyez sur Entr�.

	msgBox,, Le�on 6, %msgCours6%,
return

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la le�on 7

Cours7:
	msgCours7 = Septi�me le�on, `n `n Dans cette le�on vous apprendrez Comment cr�er et modiffier un texte dans word,  `n Puis a l'enregistrer et a l'ouvrir vous apprendrez les bases de la modification et de la navigation  `n dans un texte, vous apprendrez qu'est-ce qu'un fichier, Etc... `n `n Pour commencer la le�on, appuyez sur Entr�.

	msgBox,, Le�on 7, %msgCours7%,
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------
;Ferme le programme

GuiClose:  
   Gui, cancel
   GuiEscape:
   ExitApp  







