#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


		
;------------------------------------------------------------------------------------------------------
;
;    Fonctions pour UniversalReloader
;
;------------------------------------------------------------------------------------------------


; fonction qui ferme le programme passé en paramètre
ClosePrg(ProgName)
{
	StopProg = 1
	Loop,		; boucle sans fin
	{
		ProgRun := IfProcessExist(ProgName)	; vériffie l'existance du processus nomé nvda.exe	
		if (ProgRun = 0)			; si le programme à été arrêté avec succès
		{
			if (StopProg > 1)           ; ajoute les informations au log si ça fait plus d'une fois qu'on tente d'arrêter le programme passé en paramètre
		   	{
		   		MajLog(ProgName, "stopped", "UniversalReloader.log")
		   	}
		   	break				; on sort de la boucle
		}
		else     
		{
		   	if (StopProg > 1)      ; ajoute les informations au log si ça fait plus d'une fois qu'on tente d'arrêter le programme passé en paramètre
		   	{
		      		MajLog(ProgName, "nostopped", "UniversalReloader.log")
		   	}
		}
		process, Close, %ProgName%.exe	; on essai d'enlever le programme passé en paramètre  de la mémoire, tant qu'il n'est pas enlevé la boucle continue
		StopProg += 1
	}
}


;----------------------------------------------------------------------------------


; fonction qui écrit un fichier log dont le nom est passé en paramètre
; exemple d'utilisation MajLog("nvda", "stoped", "UniversalReloader.log")


		
MajLog(id, state, logfile)
{
    FormatTime, vdate, ddMMyyyy, HH:mm:ss dd/MM/yyyy
    FileAppend,%vdate% | %id% %state% `n , %logfile%
}

;----------------------------------------------------------------------------------

; fonction qui permet d'afficher de manière compréhensible un racourcis clavier
; le racourcis à afficher est à envoyé en paramètre
; exemple d'utilisation : ShowReloadKey := GetShowKey(%GetReloadKey%)


GetShowKey(Key)
{
    StringLen, KeyLen, Key
    if KeyLen = 3
    {
        StringMid, Key1, Key, 1, 1
        StringMid, Key2, Key, 2, 1
        StringMid, Key3, Key, 3, 1
        if Key1 = ^
        {
            kb1 = Ctrl
        }
        else if key1 = !
        {
            kb1 = Alt
        }
        else if key1 = #
        {
            kb1 = Win
        }
        Else if key1 = +
        {
            kb1 = Maj
        }
        if Key2 = ^
        {
            kb2 = Ctrl
        }
        else if key2 = !
        {
            kb2 = Alt
        }
        else if key2 = #
        {
            kb2 = Win
        }
        Else if key2 = +
        {
            kb2 = Maj
        }
        ShowKey = %kb1%+%kb2%+%key3%
    }
    else if KeyLen = 4
    {
        StringMid, Key1, Key, 1, 1
        StringMid, Key2, Key, 2, 1
        StringMid, Key3, Key, 3, 1
        StringMid, Key4, Key, 4, 1
        if Key1 = ^
        {
            kb1 = Ctrl
        }
        else if key1 = !
        {
            kb1 = Alt
        }
        else if key1 = #
        {
            kb1 = Win
        }
        Else if key1 = +
        {
            kb1 = Maj
        }
        if Key2 = ^
        {
            kb2 = Ctrl
        }
        else if key2 = !
        {
            kb2 = Alt
        }
        else if key2 = #
        {
            kb2 = Win
        }
        Else if key2 = +
        {
            kb2 = Maj
        }
        if Key3 = ^
        {
            kb3 = Ctrl
        }
        else if key3 = !
        {
            kb3 = Alt
        }
        else if key3 = #
        {
            kb3 = Win
        }
        Else if key3 = +
        {
            kb3 = Maj
        }
        ShowKey = %kb1%+%kb2%+%kb3%+%key4%
    }
	Return ShowKey
}

;----------------------------------------------------------------------------------------------------------------

; Fonction qui lance le programme envoyé en paramètre 
; le premier paramètre est le dossier du programme et le segond est son nom sans son extenssion
LoadProg(Path, Prog)
{
	Run %Path%\%Prog%.exe			; exécute le programme dont le nom sans son extenssion a été passé en paramètre

}

;-----------------------------------------------------------------------------------------------------------------------------------------------

; Vériffie l'existance d'un processus le nom du fichier sans son extenssion est passé en paramètre
; si le processus existe  on renverra le chiffre 1 dans le cas contraire ce sera le chiffre 0
IfProcessExist(Processname)
{
	process, exist, %Processname%.exe		; vériffie l'existance du processus dont le nom a été passé en paramètre
	if (ErrorLevel != 0) 		; si le processus existe
	{
		ProcessExist = 1		; on affecte la valeur 1 à la variable ProcessExist pour signalé que le processus passé en paramètre est en fonctionnement
	}
	else
	{
		ProcessExist = 0 		; on affecte la valeur 0 à la variable ProcessExist pour signaler que le processus passé en paramètre n'est pas lancé
	}
	Return ProcessExist
}





;-------------------------------------------------------------------------------------------
;
;  fin des fonctions
;
;---------------------------------------------------------------------------------------------------







