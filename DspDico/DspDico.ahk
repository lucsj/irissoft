Version = r03
NomDuScript =  Dspeech Dico - %Version%

;----------------------------------------------------------------------------------------------------------------------------------------
; Nom :				         Dspeech dico
; Language:       	   Fran�ais
; Platform:            WinXP
; Auteurs:             Luc S, 
; AutoHotkey Version:  1.0.47
; Version :			       Alpha rrelease 01
; Lissence :		       GPL
; Description :		     Remplace les mots pour les faire mieux prenoncer par DSpeech ou tout autre logiciel du m�me genre
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#SingleInstance,Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



; met dans la variable le nom du fichier � ouvrir
FileName = dictionaire.txt

; cr�ation du menu dans la zone de notiffication
Menu,Tray,Tip,%NomDuScript%
Menu,Tray,NoStandard
Menu,Tray,Icon,Dictionary.ico
Menu,Tray,DeleteAll
Menu,Tray,Add,&Aide,HELP
Menu,Tray,Add,&A propos,ABOUT
Menu,Tray,Add,
Menu,Tray,Add,&Quitter,EXIT


; si le racourcis clavier ctrl+r est appuyer le mot s�lectionn� est plac� dans le presse papier
; puis il est recherch� dans le fichier dictionaire.txt et en suite est remplac� par le mot se trouvant
; apr�s le signe �gale, affin qu'il sois mieux prenoncer 

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
                    MsgBox, Le mot %OrigWord% n'a pas �t� trouv� dans le dictionnaire `n Ajoutez le au dictionnaire en le s�lectionnant et en appuyant sur Ctrl+J 
              }
	      }
	      else
	      {
              MsgBox, le fichier %FileName% est introuvable
        }
    }
    else
    {
        MsgBox, Vous n'avez s�lectionn� aucun mot
    }

Return

; Ajouter un mot au dictionaire

^j::
      SendPlay ^c
      NewWord = %clipboard%
      IfExist, %FileName%
      {
            ; v�riffie si le mot est dans le dictionnaire
            Loop, Read, %FileName%
            {
                StringSplit, WordsArray, A_LoopReadLine, `=
                if (WordsArray1 = NewWord)
                {
                    MsgBox, le mot %NewWord% est d�ja dans le dictionaire
                    Return
                }
            }
            InputBox, ReplaceWord, Entrez le mot de la mani�re o� vous voulez le voir prenonc�
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
                    MsgBox, La ligne qui � �t� ajout� au dictionaire est : `n%Line%                
                }
                else
                {
                    MsgBox, Vous n'avez entr� aucun mots, l'ajout est annul�
                }
            }
            MsgBox, 4, , Voulez-vous Remplacer ce mot par celui que vous venez d'entr� ?
            IfMsgBox, No
            {
	             return
            }
            else
            {
                clipboard = %ReplaceWord%
                SendPlay ^v
                MsgBox, le mot %ReplaceWord% � �t� ins�r� � la place de %NewWord%
            } 
      }
	    else
	    {
          MsgBox, le fichier %FileName% est introuvable
      }
Return


; v�riffie si le mot est dans le dictionaire

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
                        MsgBox, le mot %NewWord% est d�ja dans le dictionaire
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
          MsgBox, Vous n'avez s�lectionn� aucun mot
      } 
Return

; �pelle un site internet ou une adresse mail

^e::

      clipboard = 
      SendPlay ^c
      if (clipboard <> "" )
      {
            Orig = %clipboard%
            
            
            clipboard = %Orig%, J'�pelle, <SPELL>%clipboard%</SPELL>
            SendPlay ^v
      }
      else
      {
          MsgBox, Vous n'avez s�lectionn� aucun mot
      } 
Return

; exemple d'utilisation de la fonction stringreplace
; StringReplace,clipboard,clipboard,-, tir�`, , all



; Fonction qui affiche une bo�te d'aide

HELP:
MsgBox, Utilisation du programme : `n `n Pour remplacer un mot par une version phon�tique qui est mieux prenonc� `n s�lectionner le mot � remplacer et appuyez sur : `n`n CTRL+R `t le mot sera remplac� automatiquement par sa version phon�tique mieux prenonc� par la synth�se `n Alt+v `t v�riffie si un mot est pr�sent dans le dictionaire, `n Ctrl+j `t ajouter un mot au dictionnaire,`n Ctrl+e  `t Pour faire �peler une adresse e-mail ou une adresse d'un site web
Return

; fonction qui affiche la bo�te de dialogue a propos 

ABOUT:
      MsgBox, %NomDuScript% : `n est une application qui permet de cr�er un dictionnaire pour DSPeech `n ce petit programme sans pr�tention permet de remplacer un mot mal prenonc� par  sa correspondance phon�tique qui sera mieux prenonc� `n Pour cela vous devez �diter le fichier dictionaire.txt `n et mettre le mot horiginal, puis le signe �gale, et le mot qui sera bien prenonc�, `n attention, � ne pas ajouter d'espace, et pas de ligne vide � la fin du fichier
Return


EXIT:
ExitApp


