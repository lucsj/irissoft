Version = r10
NomDuScript =  TutoInfo  %Version%


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Nom :				TutoInfo		
; Language:       	Français
; Platform:         WinXP
; Auteur:           IrisSoft
; AutoHotkey     	Version: 1.0.47
; Version :			Alpha rrelease 10
; Lissence :		GPL ou LGPL (pas encore choisit mais en tout cas il sera en lissence libre)
; Description :	Ce programme permettra aux déficients visuels, de se former seul a l'informatique, ou a un proffesseur d'informatique ;				  de pouvoir enseigner plus efficacement a plusieurs élèves enmême temps,  grâce a l'écoute de cours, aux QCM et  
;				aux exercices qui seront proposé les élèves progressivement acquérirons les conaissances requises, sans que leur 
;				professeur soie la tous le temps pour les aider, et pouront refaire les cours qu'ils ont étudiés 
;				tous seul chez eux pour se perfectioner
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoTrayIcon

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



;création d'une listebox avec le contenu de la variable items

   ; défini et affecte la variable items, qui remplira la zonne de liste
   items = 1 - les bases de l'informatique||2 - Windows le bureau explications|3 - Le bureau, le menu démarrer et la barre des tâches|4 - Ouvrir et fermer un programme|5 - Le menu démarrer|6 - Word, exploration des menus|7 - Word, edition de texte

   ;initialiser la fenêtre avec le texte et la liste
   Gui, Font, S12 CDefault, Arial							  ; Choix de la police d'affichage du logiciel et de sa taille
   Gui, Add, Text, x6 y10 w150 h20, Choisissez une leçon` :  
   Gui, Add, ListBox, vChoice w500 h300 hscroll vscroll, %items%
   Gui, Add, Button, vSend gValide x110 y340 w60 h21 +Default, &Valider
   Gui, Add, Button, vCancel gGuiClose x260 y340 w60 h21, A&nnuler

   ; affiche la fenêtre programmé
   Gui, Show,,   %NomDuScript% - Tutoriel Informatique

   ;la touche échap a pour effet de quitter imédiatement le programme
   Escape::
        Gosub GuiClose        
   return
return 

  
;--------------------------------------------------------------------------------------------
; Fonctions
;------------------------------------------------------------------------------------------


; cette fonction est lancé quand on valide sur la liste, elle renvoie le choix dans la variable Choice
Valide:
   Gui, submit,   
   GuiControlGet, Choice                             ; Renvoie le choix fait par l'utilisateur
   Gosub, TestChoice
   msgBox,, Tuto informatique, Merci d'avoir utilisé TutoInfo`, `n`n  ce programme est encore en phase alpha de son développement`, `n et donc peut présenter quelques défaillances ou erreurs de jeunesse`,  `n merci de vôtre patience.,
   Gosub, GuiClose
return  

;----------------------------------------------------------------------------

;teste quel item de laliste a été choisit par l'utilisateur
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

;la première leçon du tuto
Cours1:
	Cours1Line1 = Première leçon `n `n
	Cours1Line2 = Dans ce cours vous découvrirez ce qu'est windows, a quoi il sert et ses principes de bases `n
	Cours1Line3 = Ainsi que ce qu'est un système d'exploitation. `n`n
	Cours1Line4 = Pour commencer la leçon appuyez sur Entré `n
	msgCours1 = %Cours1Line1% %Cours1Line2% %Cours1Line3% %Cours1Line4%

	msgBox,, Leçon 1,  %msgCours1%,
return

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; la fonction qui lance la leçon 2
Cours2:
	msgCours2 = Deuxième leçon `n`n Dans cette leçon vous apprendrez ce qu'est le bureau, comment y aller et comment choisir ubne icône, `n Vous apprendrez aussi plusieurs solutions pour retrouver rapidement un programme et pour explorer le contenu du bureau. `n`n Pour commencer la leçon, appuyez su rentré`n

	msgBox,, Leçon 2, %msgCours2%,

return

;---------------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la leçon 3

Cours3:
	MsgCours3 = Troisième leçon `n`n Dans cette leçon vous apprendrez ce qu'est la barre des tâches le menu démarrer, `n comment naviguer entre ces trois éléments a quoi ils servent `n et comment les utiliser. `n`n Pour commencer la leçon, appuyez sur entré `n

	msgBox,, Leçon 3, %msgCours3%,
return


;-----------------------------------------------------------------------------------------------------
; la fonction qui lance la leçon 4

Cours4:
	msgCours4 = Quatrième leçon, `n`n Dans cette leçon nous allons apprendre comment lancer et arrêter un programme `n on vas apprendre aussi a conaître a quoi serve certains programmes etc... `n `n Pour commencer la leçon, appuyez sur entré. `n

	msgBox,, Leçon 4, %msgCours4%,
return


;----------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la leçon 5

Cours5:
	msgCours5 = Cinquième leçon, `n `n Dans cette leçon vous apprendrez ce qu'est le menu démarrer, `n comment l'utiliser, l'explorer et comment ouvrir un programme en l'utilisant `n Vous aprendrez ce qu'est un menu, ce qu'est un sous-menu `n et les touches de navigation a l'intérieur des menus `n `n Pour commencer la leçon, appuyez sur Entré.

	msgBox,, Leçon 5, %msgCours5%,
return


;-----------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la leçon 6

Cours6:
	msgCours6 = Sixième leçon, `n `n Dans cette leçon vous apprendrez ce qu'est Microsoft Word,  `n A quoi sert un traitement de texte, qu'est-ce que les menu d'un logiciel, comment les utiliser  `n Vous découvrirez les principaux menus de Word, et leur utilité`n `n Pour commencer la leçon, appuyez sur Entré.

	msgBox,, Leçon 6, %msgCours6%,
return

;--------------------------------------------------------------------------------------------------------------------------------------------------------------
; la fonction qui lance la leçon 7

Cours7:
	msgCours7 = Septième leçon, `n `n Dans cette leçon vous apprendrez Comment créer et modiffier un texte dans word,  `n Puis a l'enregistrer et a l'ouvrir vous apprendrez les bases de la modification et de la navigation  `n dans un texte, vous apprendrez qu'est-ce qu'un fichier, Etc... `n `n Pour commencer la leçon, appuyez sur Entré.

	msgBox,, Leçon 7, %msgCours7%,
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------
;Ferme le programme

GuiClose:  
   Gui, cancel
   GuiEscape:
   ExitApp  







