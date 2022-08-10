#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

!Space:: Send {Space}
return
!Enter:: Send {Enter}
return

^Q:: Send !{F4}
return 

!h:: Send {left}
return
^!h:: Send ^{left}
return
+!h:: Send +{left}
return
^+!h:: Send ^+{left}
return
#!h:: Send #{left}
return

!k:: Send {up}
return
^!k:: Send ^{up}
return
+!k:: Send +{up}
return
^+!k:: Send ^+{up}
return
#!k:: Send #{up}
return

!j:: Send {down}
return
^!j:: Send ^{down}
return
+!j:: Send +{down}
return
^+!j:: Send ^+{down}
return
#!j:: Send #{down}
return

!l:: Send {right}
return
^!l:: Send ^{right}
return
+!l:: Send +{right}
return
^+!l:: Send ^+{right}
return
#!l:: Send #{right}
return


!d:: Send {Backspace}
return
^!d:: Send ^{Backspace}
return

