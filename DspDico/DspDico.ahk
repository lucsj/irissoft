Version = r03
NomDuScript =  Dspeech Dico - %Version%

;----------------------------------------------------------------------------------------------------------------------------------------
; Nom :				         Dspeech dico
; Language:       	   Français
; Platform:            WinXP
; Auteurs:             Luc S, 
; AutoHotkey Version:  1.0.47
; Version :			       Alpha rrelease 01
; Lissence :		       GPL
; Description :		     Remplace les mots pour les faire mieux prenoncer par DSpeech ou tout autre logiciel du même genre
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance,Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



; met dans la variable le nom du fichier à ouvrir
FileName = dictionaire.txt

; création du menu dans la zone de notiffication
Menu,Tray,Tip,%NomDuScript%
Menu,Tray,NoStandard
Menu,Tray,Icon,Dictionary.ico
Menu,Tray,DeleteAll
Menu,Tray,Add,&Aide,HELP
Menu,Tray,Add,&A propos,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Quitter,EXIT


; si le racourcis clavier ctrl+r est appuyer le mot sélectionné est placé dans le presse papier
; puis il est recherché dans le fichier dictionaire.txt et en suite est remplacé par le mot se trouvant
; après le signe égale, affin qu'il sois mieux prenoncer 

^r::
    clipboard = 
    SendPlay ^c
    if (clipboard <> "" )
    {
        OrigWord = %clipboard%
        IfExist, %FileName%
        {
              Loop, Read, %FileName%
      	      {
   		             StringSplit, WordsArray, A_LoopReadLine, `=
                   if (WordsArray1 = OrigWord)
                   {
                        ReplaceWord = %WordsArray2%
                        Break
                   }
	            }
              if (ReplaceWord)
              {
                    clipboard = %ReplaceWord%
                    SendPlay ^v
              }     
              else
              {
                    MsgBox, Le mot %OrigWord% n'a pas été trouvé dans le dictionnaire `n Ajoutez le au dictionnaire en le sélectionnant et en appuyant sur Ctrl+J 
              }
	      }
	      else
	      {
              MsgBox, le fichier %FileName% est introuvable
        }
    }
    else
    {
        MsgBox, Vous n'avez sélectionné aucun mot
    }

Return

; Ajouter un mot au dictionaire

^j::
      SendPlay ^c
      NewWord = %clipboard%
      IfExist, %FileName%
      {
            ; vériffie si le mot est dans le dictionnaire
            Loop, Read, %FileName%
            {
                StringSplit, WordsArray, A_LoopReadLine, `=
                if (WordsArray1 = NewWord)
                {
                    MsgBox, le mot %NewWord% est déja dans le dictionaire
                    Return
                }
            }
            InputBox, ReplaceWord, Entrez le mot de la manière où vous voulez le voir prenoncé
            if ErrorLevel <> 0
            {
              	MsgBox, Annulation !
              	Return
            }              	
            else
            {
                if (NewWord)
                {
                    Line = %NewWord%=%ReplaceWord%
                    FileAppend, `r`n%Line%,%FileName%
                    MsgBox, La ligne qui à été ajouté au dictionaire est : `n%Line%                
                }
                else
                {
                    MsgBox, Vous n'avez entré aucun mots, l'ajout est annulé
                }
            }
            MsgBox, 4, , Voulez-vous Remplacer ce mot par celui que vous venez d'entré ?
            IfMsgBox, No
            {
	             return
            }
            else
            {
                clipboard = %ReplaceWord%
                SendPlay ^v
                MsgBox, le mot %ReplaceWord% à été inséré à la place de %NewWord%
            } 
      }
	    else
	    {
          MsgBox, le fichier %FileName% est introuvable
      }
Return


; vériffie si le mot est dans le dictionaire

!v::
      clipboard = 
      SendPlay ^c
      if (clipboard <> "" )
      {
          NewWord = %clipboard%
          IfExist, %FileName%
          {
              Loop, Read, %FileName%
              {
                  StringSplit, WordsArray, A_LoopReadLine, `=
                  if (WordsArray1 = NewWord)
                  {
                        MsgBox, le mot %NewWord% est déja dans le dictionaire
                        word = 1
                        Return
                  }
              }
          }
	        else
	        {
              MsgBox, le fichier %FileName% est introuvable
          }
          if (word <> 1)
          {
              MsgBox, Le mot %NewWord% n'est pas dans le dictionaire    
          }
      }
      else
      {
          MsgBox, Vous n'avez sélectionné aucun mot
      } 
Return

; épelle un site internet ou une adresse mail

^e::

      clipboard = 
      SendPlay ^c
      if (clipboard <> "" )
      {
            Orig = %clipboard%
            
            
            clipboard = %Orig%, J'épelle, <SPELL>%clipboard%</SPELL>
            SendPlay ^v
      }
      else
      {
          MsgBox, Vous n'avez sélectionné aucun mot
      } 
Return

; exemple d'utilisation de la fonction stringreplace
; StringReplace,clipboard,clipboard,-, tiré`, , all



; Fonction qui affiche une boîte d'aide

HELP:
MsgBox, Utilisation du programme : `n `n Pour remplacer un mot par une version phonétique qui est mieux prenoncé `n sélectionner le mot à remplacer et appuyez sur : `n`n CTRL+R `t le mot sera remplacé automatiquement par sa version phonétique mieux prenoncé par la synthèse `n Alt+v `t vériffie si un mot est présent dans le dictionaire, `n Ctrl+j `t ajouter un mot au dictionnaire,`n Ctrl+e  `t Pour faire épeler une adresse e-mail ou une adresse d'un site web
Return

; fonction qui affiche la boîte de dialogue a propos 

ABOUT:
      MsgBox, %NomDuScript% : `n est une application qui permet de créer un dictionnaire pour DSPeech `n ce petit programme sans prétention permet de remplacer un mot mal prenoncé par  sa correspondance phonétique qui sera mieux prenoncé `n Pour cela vous devez éditer le fichier dictionaire.txt `n et mettre le mot horiginal, puis le signe égale, et le mot qui sera bien prenoncé, `n attention, à ne pas ajouter d'espace, et pas de ligne vide à la fin du fichier
Return


EXIT:
ExitApp


