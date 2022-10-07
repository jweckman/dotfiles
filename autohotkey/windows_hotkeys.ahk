#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Switch workspaces
^#z::^#Left
^#x::^#Right

; Move window between workspaces
+#z::
  WinGetTitle, Title, A
  WinSet, ExStyle, ^0x80, %Title%
  Send {LWin down}{Ctrl down}{Left}{Ctrl up}{LWin up}
  sleep, 50
  WinSet, ExStyle, ^0x80, %Title%
  WinActivate, %Title%
Return

+#x::
  WinGetTitle, Title, A
  WinSet, ExStyle, ^0x80, %Title%
  Send {LWin down}{Ctrl down}{Right}{Ctrl up}{LWin up}
  sleep, 50
  WinSet, ExStyle, ^0x80, %Title%
  WinActivate, %Title%
Return

; Swap caps lock and escape
CapsLock::Escape
Escape::CapsLock

; Allow using j and k keys instead of arrow keys to move window location
#j::#left
#k::#right

; Bind win + m to maximize window. Minimize is not needed for anything
#m::WinMaximize, A

; Make win + CapsLock (remapped to Escape) close the current window
#CapsLock::WinClose, A


^!t::
Run,wt,,max,
Sleep 500 
Send, {LWin Down}{LShift Down}{RIGHT}{LShift Up}{LWin Up}
return
