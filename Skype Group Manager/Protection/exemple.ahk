; AutoHotkey Version: 1.0.39+
; Language:  English
; Platform:  Win2000/XP
; Author:    Laszlo Hars <www.Hars.US> 
; Function:  SW Copy Protection

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
MsgBox,,,This Software is registered to`n%User% at %Email%,4

MsgBox You are registered to use this software   ; add your code here

;Password Protection Part

IniRead, validPassword, SafeSW.INI, Login, Password, %A_Space%
validPassword = %validPassword%

Gui 2:-Sysmenu
Gui, 2:Margin, 5,5
Gui, 2:Add, Groupbox, w220 h50, Enter Password
Gui, 2:Font, S10, Verdana
Gui, 2:Add, Edit, x15 y20 r1 Limit20 w200 h20 0x20 vTypedPassWord
Gui, 2:Add, Button, x+15 y10 w45 h45 0x8000 +Default gVerifyPassword, &Ok
Gui, 2:Show, AutoSize ,Logon
Return

VerifyPassword:
Gui, 2:Submit, Nohide

ChkPassword := HASH( TypedPassword, StrLen( TypedPassword), 4 )

If ( validPassword = "" AND TypedPassword = "" )
    ExitApp

If ( validPassword = "" AND ChkPassword != "" )
 {
    IniWrite, %ChkPassword%, SafeSW.INI, Login, Password
    ExitApp
 }

If ( ChkPassword != validPassword )
 {
   Msgbox, 16, Login Error!, Invalid Password!, 5
   ExitApp
   Return
 }
Else
 {
   Msgbox, 64, Login Succeeded!, You typed the correct password, 5

CloseGui2:
Gui, 2:Destroy

;Put Main Gui + script here

Gui, Color, Black, var48
Gui, Font, S14 Cgreen w600, Arial
Gui, Add, Text, x26 y20 w420 h30 +Center, Rob's Auto Talker
Gui, Font, S14 Cblue Bold, Arial
Gui, Add, Text, x26 y120 w50 h20 , Text
Gui, Add, Button, x286 y70 w90 h30 , Start
Gui, Font, S10 Cred w600, Arial
Gui, Add, Edit, x86 y120 w360 h20 Text vtext,
Gui, Font, S9 Cyellow w600, Arial
Gui, Add, Text, x176 y160 w260 h20 , Created By: HCProfessionals
Gui, Font, S10 Cblue w600, Arial
Gui, Add, Text, x26 y70 w70 h20 , Repeat:
Gui, Font, S10 Cred w600, Arial
Gui, Add, Edit, x106 y70 w110 h20 vrepeat,
Gui, Font, S10 Cyellow w600, Arial
; Generated using SmartGUI Creator 4.0
Gui, Show, x573 y158 h203 w489, Rob's Auto Talker - Diablo 2
Return ;must have return after GUI!

ButtonStart:
WinWait, D2Loader v1.11b - Build On Nov 11 2005,
IfWinNotActive, D2Loader v1.11b - Build On Nov 11 2005, , WinActivate, D2Loader v1.11b - Build On Nov 11 2005,
WinWaitActive, D2Loader v1.11b - Build On Nov 11 2005,
Gui, Submit, Nohide
{
   WinActivate, D2Loader v1.11b - Build On Nov 11 2005
   Sleep, 150
   {
      Loop, %repeat%
      {
         Random, Var, 2471, 3192
         Sleep, %Var%
         Random, Var2, 2843, 3072
         Sleep, %Var2%
         Random, Var3, 3287, 4283
         Sleep, %Var3%
         Random, Var5, 1543, 2234
         Sleep, %Var5%
         Random, Var6, 72, 125
         SetKeyDelay, %Var6%
         Send, %text%
         Random, Var7, 714, 1103
         Sleep, %Var7%
         Send, {ENTER}
      }
   }
}
Return

GuiClose:
ExitApp

;End of main script

 }
Return

GuiEscape:
 ExitApp
Return

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
      S =
      (  LTrim
         To: someone@someone.com
         Username = <enter your full name here>
         Your email address = <where you want the unlock code sent>
         PC Fingerprint = %Fingerprint%
      )
      ClipBoard = %S%
      MsgBox Please Register! Email the following information`n`n%S%`n`n(it has been copied to the ClipBoard)
      MsgBox Opening default e-mail application
      Run, mailto:someone@someone.com
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


