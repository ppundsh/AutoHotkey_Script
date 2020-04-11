;發佈位置：https://www.plurk.com/p/njsw4d 原始來源：https://sspai.com/post/57157
;版本0.1

;左鍵按住再按r 重新載入
~LButton & r::
reload
return

;連續按兩下Alt切換分層----------------------------------------------------------------
~Alt::
        keyWait, Alt
	if IsDoubleClick() {
		RemapKeys := !RemapKeys
		if RemapKeys
			ShowTransText("ALT Mode")
		else
			ShowTransText()
	}
return

#If RemapKeys
	j::Left
	l::Right
	i::Up
	k::Down
#If

IsDoubleClick() {
	static doubleClickTime := DllCall("GetDoubleClickTime")
	KeyWait, % LTrim(A_ThisHotkey, "~")
	return (A_ThisHotKey = A_PriorHotKey) && (A_TimeSincePriorHotkey <= doubleClickTime)
}

; ShowTransText("Hello")
; ShowTransText("Hello", 10, 10, {bgColor:"0x1482DE", textColor:"White"})
ShowTransText(Text := "", X := 0, Y := 0, objOptions := "") {
	if (Text = "") {
		Gui, @STT_:Destroy
		return
	}

	o := {bgColor:"Black", textColor:"0x00ff00", transN:200, fontSize:12}
	for k, v in objOptions {
		o[k] := v
	}
	
	Gui, @STT_:Destroy
	Gui, @STT_:+AlwaysOnTop -Caption -SysMenu +ToolWindow +E0x20 +HWNDhGUI
	Gui, @STT_:Font, % "s" o.fontSize
	Gui, @STT_:Color, % o.bgColor
	Gui, @STT_:Add, Text, % "c" o.textColor, %Text%
	Gui, @STT_:Show, x%X% y%Y% NA
	WinSet, Transparent, % o.transN, ahk_id %hGUI%
}



;連續按兩下ctrl
~Control::
if (A_PriorHotkey != "~Control" or A_TimeSincePriorHotkey > 400)
{
    ; Too much time between presses, so this isn't a double-press.
    KeyWait, Control
    return
}
Send !{F12}{Alt Up}
return




;  ***  space
space::Send {space}

^space::Send ^{space}
#space::Send #{space}
^#space::Send ^#{space}
!space::Send !{space}
^!space::Send ^!{space}

;  *** space + Num
space & 4::Send {space}{space}{space}{space}
space & 8::Send {space}{space}{space}{space}{space}{space}{space}{space}

;連續貼上----------------------------------------------
#if GetKeyState("space", "P")
^v::
;初始化，如果沒有"上次執行的時間"，就設定"已經貼上次數為零"
if LastTime <1
{
    V_presses :=0
}

;如果有"上次執行的時間"，將本次時間減掉上次執行的時間取得兩次間隔時間，並將"已經貼上次數"加一
if LastTime >0
{
    ElapsedTime := A_TickCount - LastTime
    V_presses += 1
}

;如果兩次間隔時間超過10000毫秒，那把"上次執行時間"歸零，並把"已經貼上次數"歸零。
if ElapsedTime >10000
{
    LastTime :=0
    V_presses :=0
}

;執行"win + V"，並按照"已經貼上次數"執行"down"，最後按enter並紀錄最後執行時間。
Send, #v
Sleep, 200
Loop %V_presses%
{
    Send {down}
    Sleep, 50
}
Sleep, 200
Send {Enter}

LastTime :=A_TickCount

return
;----------------------------------------------------------------------



;  *** space + [] (windows virual desktop switcher)
space & [::Send ^#{left}
space & ]::Send ^#{right}

;  *** space + XX
#if GetKeyState("space", "P")
f & i:: Send +{up}
f & j:: Send +{left}
f & k:: Send +{down}
f & l:: Send +{right}
d & i:: Send ^{up}
d & j:: Send ^{left}
d & k:: Send ^{down}
d & l:: Send ^{right}
;g & i:: Send ^+{up} 
g & j:: Send ^+{left}
;g & k:: Send ^+{down}
g & l:: Send ^+{right}

i:: Send {up}
j:: Send {left}
k:: Send {down}
l:: Send {right}
h:: Send {home}
n:: Send {end}
o:: Send {Pgup}
.:: Send {Pgdn}

c:: Send {Backspace} 
x:: Send ^x
v:: Send {Delete}
z:: Send ^z

1:: Send {F4}
2:: Send {F2}
3:: Send {F3}

5:: Send {F5}
6:: Send {F6}
7:: Send {F9}

9:: Send {F11}
0:: Send {F12}

return

;-------------------------------------------------------------------------
;在任務欄上滾動鼠標來調節音量.
#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}
MButton::Send,{Volume_Mute}  
WheelDown::Send {Volume_Down}

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}
return


