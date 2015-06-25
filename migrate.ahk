
; This script will present a GUI interface to chose a source environment
; from which to save a routine, and a target environment to which to load
; that routine. Currently script assumes that reflection session is at either
; the lookitt prompt or the cache prompt. If not, script will error and routine
; will not be loaded.

#SingleInstance, FORCE

^!l::

Gui, Show, w500 h200, Move A Routine
Gui, Add, Text,, Select a Source Environment:
Gui, Add, DropDownList, vSourceEnv w450 r20, %List%
Gui, Add, Text,, Select a Target Environment:
Gui, Add, DropDownList, vTargetEnv w450 r20, %List%
Gui, Add, Text,, Enter the routine you would like to move:
Gui, Add, Edit, r1 vRoutine
Gui, Add, Button, gPressed x10 y145, &Move Routine
Gui, Add, Button, gGetList x90 y145, &Refresh Env List
Gui, Add, Button, gClosed x181 y145, C&lose

Goto, GetList

GetList:
List = 
WinGet, WinList, List,,, Program Manager
loop,%WinList%
{
Current:=Winlist%A_Index%
WinGetTitle, WinTitle, ahk_id %Current%
WinGetClass, WinClass, %WinTitle%
If (WinTitle AND WinClass="r2Window")
List.=WinTitle "|"
}
GuiControl,, TargetEnv, |%List%
GuiControl,, SourceEnv, |%List%	
Return


; Change code within the Else block perform whatever actions are needed in each text shell
Pressed:
If (A_GuiControl = "&Move Routine") {
	Gui, Submit, NoHide
	If (TargetEnv="" or SourceEnv="" or Routine="") {
		Goto, Error
		}
	Else {
		WinActivate,%SourceEnv%
		Sleep 100
		Send d {^}{U+0025}ZeRSAVE
		Send {Enter}
		Send %Routine%{Enter}
		Send {Enter}
		Send /nfs/3day/%Routine%{Enter}
		Send {Enter}
		Send {Enter}

		Sleep 1500

		WinActivate, %TargetEnv%
		Sleep 100
		Send d {^}{U+0025}ZeRLOAD
		Send {Enter}
		Send /nfs/3day/%Routine%{Enter}
		Send a{Enter}
		Send {Enter}
		Send {Enter}
		Send {Enter}
		Send y{Enter}
		Send {Enter}
		Return
	}
}
Else {
	Return
}

Error:
MsgBox, All fields are required
Return

!l::
Closed:
List = 
Gui, Destroy
Return

GuiClose:
Goto, Closed