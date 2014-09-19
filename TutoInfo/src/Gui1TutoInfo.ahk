#NoTrayIcon


   ; Assiniations des variables version, nom, et titre1
   version = r20
   nom = TutoInfo V Alpha %version%
   titre1 = %nom% - Tuto Informatique pour Déficients Visuel

   ; défini et affecte la variable items, qui remplira la zonne de liste
   items = 1 - les bases de l'informatique||2 - Windows le bureau explications|3 - Le bureau, le menu démarrer et la barre des tâches|4 - Ouvrir et fermer un programme|5 - Le menu démarrer|6 - Word, exploration des menus|7 - Word, edition de texte



  ; Créer le GUI principal avec une marge
  Gui, Margin, 5, 5

  ; Choix de la police d'affichage du logiciel et de sa taille
  Gui, Font, S12 CDefault, Arial

   ;Création de l'interface graphique
   Gui, Add, GroupBox, x150  y30  w500 h90, Thèmes 
   Gui, Add, Text, x170 y55 w400 h20, Choisissez un thème de cours 
   Gui, Add, ListBox, x170 y80 w320 h30 vscroll, Initiation à l'informatique sous Windows XP || Initiation au lecteur d'écran NVDA
   Gui, Add, Button, x500 y74 w120 h30, Choisir
   Gui, Add, GroupBox, x90 y150 w600 h420, Cours d'informatique 
   Gui, Add, Text, x110 y190 w300 h20, Choisissez une leçon : 
   Gui, Add, ListBox, x110 y220 w400 h340 vscroll, %items%
   Gui, Add, Button, x535 y220 w120 h30 default, Valider
   Gui, Add, Button, x535 y280 w120 h30, Change thème  
   Gui, Add, Button, x535 y340 w120 h30, Créer cours
   Gui, Add, Button, x535 y400 w120 h30, A propos
   Gui, Add, Button, x535 y519 w120 h30, Quitter TutInfo
  

   ; Affichage de la fenêtre
   Gui, Show, w800 h600, %titre%
 


; lignes a enlever après le dévelopent de la nouvelle interface graphique
   Escape::
        Gosub GuiClose        
   return

GuiClose:  
   Gui, cancel
   GuiEscape:
   ExitApp  





