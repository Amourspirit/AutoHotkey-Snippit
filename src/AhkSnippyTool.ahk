;{ License
/* Copyright (C) 2014-2018  Paul Moss
 * 
 * This file is part of AhkSnippy.
 *
 * AhkSnippy is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * AhkSnippy is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License 
 */
; End:License ;}



;{ Directives
#SingleInstance force
#NoEnv
#Persistent
 
; include for Super Glocal AS_AppDatapath that contains the path to the current data folder
#include *i %A_AppData%\AutoHotkey Snippit\PluginData.ahk ; *i so the file can be non-existant
; set hotstrings so they only respond to new line and tab
;Hotstring EndChars `n`t
#include *i %A_AppData%\AutoHotkey Snippit\endchars.ahk ; *i so the file can be non-existant
; End:Directives ;}
;{ Include
#Include <inc_mf_0_4>
#Include <inc_mf_System_IO_0_4>
#Include <Class_ErrorBoxResult>
#Include <Inc_Debug>
#Include <Inc_Script>
#Include <Class_BlackWhiteList>
#Include <xpath>
#Include <Class_XmlHelper>
#Include <Class_SnipyRI>
#Include <Class_SnippyResourceManager>
#Include <profile>
#Include <Class_ProfileMain>
#Include <Class_Settings>
#Include <Class_AppSettings>
#Include <Inc_public>

Global LanguagePack := "en-US" ; set the default language for Resource Files
OnExit("ExitFunc")
if(!A_IsCompiled) {
	; Script Debug can be from 0 (no debugging) to 3 (highly verbose debugging)
	Script.dbg := 0 ; set debug to true temporarlly
}

;{ globals
Script.ThisScript := "AhkSnippyTool"
Script.Res := SnipyRI.Instance

;{ Debug System Envrioment
if (Script.dbg)
{
	Debug("A_AhkVersion: {0}", A_AhkVersion)
	Debug("A_OSType: {0}", A_OSType)
	Debug("A_OSVersion: {0}", A_OSVersion)
	Debug("A_PtrSize: {0}", A_PtrSize)
	Debug("A_Language {0}", A_Language)
	Debug("A_IsAdmin: {0}", A_IsAdmin)
	Debug("A_ScreenWidth: {0}", A_ScreenWidth)
	Debug("A_ScreenHeight: {0}", A_ScreenHeight)
	Debug("A_ScriptHwnd: {0}", A_ScriptHwnd)
}

OnMessage(0x4a, "Receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA
Script.conf := new Settings()

; save the App settings to update the script path and running state
aSet := new AppSettings()
aSet.Save()
aSet := Null

try {
	
	objProfile := new ProfileMain()
	objProfile.Init(Script.conf.ProfileCurrent)
	
	Script.Profile := objProfile
} catch e {
	DebugError(e, 1, A_ScriptName, A_LineNumber)
	HandleError(e)
}

if (Script.Profile.ReloadRequired)
{
	strTitle := Script.Res.GetResourceString("ReloadRequiredTitle")
	strMsg := Script.Res.GetResourceString("ReloadRequiredMsg", "`n")
	MsgBox, 36, %strTitle%, %strMsg%
	IfMsgBox Yes
	    Goto, ScriptReload
	else
	    ExitApp
}
; End:Debug System Envrioment ;}

global CcTabCount := 0
global WhiteList := new BlackWhiteList()
; If Whitelist.GlobalProfile is true then profile will be active on all window across entire system.
WhiteList.GlobalProfile := Script.Profile.globalProfile
for i, win in Script.Profile.windows
{
	Debug("Adding '{1}' to white list for '{0}'", win.value, win.name)
	WhiteList.Add(win.value)
	
}

global SnipitFolder		:= Script.Profile.PathSnips ;A_ScriptDir . "\" . "Snips"
global xmlDoc			:= ""
global Cache			:= new MfDictionary()
global SnipFiles		:= new MfDictionary()
global UseCache			:= true
HasDynamicHotstrings	:= true
menu, tray, NoStandard ; remove standard menu items
if (FileExist(Script.conf.AppHotList))
{
	;
	sResource := Script.Res.GetResourceStringBySection("ListManager", "GUI")
	Menu, tray, add, %sResource%, DisplayHotlist  ; Creates a new menu item.
	Menu, tray, Default, %sResource%
	sResource := Null
}

if (FileExist(Script.conf.AppSwap))
{
	;sResource := Script.Res.GetResourceStringBySection("ChangeProfile", "GUI")
	sResource := Script.Profile.codeLanguage.codeName
	Menu, tray, add, %sResource%, DisplayProfileSwap  ; Creates a new menu item.
	sResource := Null
}
Menu, tray, add  ; Creates a separator line.
winspy := A_ProgramFiles . "\AutoHotkey\AU3_Spy.exe"
if(FileExist(winspy))
{
	sResource := Script.Res.GetResourceStringBySection("WindowSpy", "GUI")
	Menu, tray, Add, %sResource%, RunSpy  ; Creates a new menu item.
	sResource := Null
}
Menu, tray, add  ; Creates a separator line.

sResource := Script.Res.GetResourceStringBySection("Reload", "GUI")
Menu, tray, Add, %sResource%, ScriptReload  ; Creates a new menu item.
sResource := Null

sResource := Script.Res.GetResourceStringBySection("Pause", "GUI")
Menu, tray, Add, %sResource%, PauseScript  ; Creates a new menu item.
sResource := 

sResource := Script.Res.GetResourceStringBySection("Suspend", "GUI")
Menu, tray, Add, %sResource%, SuspendScript  ; Creates a new menu item.

sResource := Null

Menu, tray, add  ; Creates a separator line.
sResource := Script.Res.GetResourceStringBySection("Help", "GUI")
Menu, tray, Add, %sResource%, ShowHelp  ; Creates a new menu item.
sResource := Null
Menu, tray, add  ; Creates a separator line.
sResource := Script.Res.GetResourceStringBySection("Donate", "GUI")
Menu, tray, Add, %sResource%, Donate  ; Creates a new menu item.
sResource := Null
Menu, tray, add  ; Creates a separator line.

sResource := Script.Res.GetResourceStringBySection("Exit", "GUI")
Menu, tray, add, %sResource%, ScriptExit ; Add Exit script back to menu
Menu, tray, icon, %A_ScriptDir%\icons\icon.ico
sResource := Null

;Menu, Tray, Icon, Script Icon, %A_ScriptDir%\icons\icon.ico
;Menu, Tray, Icon, Suspend Icon, %A_ScriptDir%\icons\suspend.ico
;Menu, Tray, Icon, Pause Icon, %A_ScriptDir%\icons\pause.ico


; End:globals ;}

;#if (WhiteList.GetWindowActive())

; forece hotkey to only fire if scite is active

return

;{ SetProgress - Display message on screen via progress
SetProgress(Msg, ShowDisplay = true) {
	if (ShowDisplay)
	{
		xPos := (A_ScreenWidth - 320)
		yPos := (A_ScreenHeight - 110)
		Progress, m1 b fs13 zh0 WMn700 x%xPos% y%yPos%, %msg%
	} else {
		Progress, Off
	}
}
; End:SetProgress - Display message on screen via progress ;}

#if
;{ Subs  -No black or white listed subroutines
;{ ProgressOff Turns progress display off
ProgressOff:
Progress, Off
return
; 	End:ProgressOff Turns progress display off ;}

; End:Subs  -No black or white listed subroutines ;}
;{ Functions()


GetInput(Title, Text, InitialValue="") {
	result := InitialValue
	if (!MfString.IsNullOrEmpty(InitialValue))
	{
		if (InitialValue = "%clipboard%") {
			result := Clipboard
		}
	}
	
	try {
		InputResult := cInputBox(Title, Text, result)
		
		if (InputResult)
		{
			result := InputResult
		} else {
			result := MfString.Empty
		}
	} catch e {
		ex := new MfException(MfString.Format(MfEnvironment.Instance.GetResourceString("Exception_Error"), A_ThisFunc), e)
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
	return result
}
;{ PasteSnip
/*
	Function: PasteSnip(funcParam)
		PasteSnip() Paste Snippit into code window
	Parameters:
		Name - the name of the Snippit to paste if extension is absent then .ahk is assumed
		Method - Optional name of the method that is calling PasteSnip
		AddTabs - Optional if true the tabs are added to the start of the Snip Text. Default is True
		ForceClear - If true any text on the current line before the cursor wiped before inserting snippit
			This is useful when autocomplete tries to complete a word from your hotstring.
	Returns:
		Returns true if no errors
	Throws:
		Throws MfException on general Errors
*/
PasteSnip(Name, Method="", AddTabs=true, ForceClear=false) {
	DebugLevel("{0} Entered", 1, A_ThisFunc)
	DebugLevel("{0} Params - Name:'{1}' Method:'{2}' AddTabs:'{3}' ForceClear:'{4}'", 2
		, A_ThisFunc, Name, Method, AddTabs, ForceClear)
	retval := false
	if (Method) {
		_m := Method
	} else {
		_m := A_ThisFunc
	}
	clip := ""
	try {
		strSnip := GetSnipText(Name, Method)
		strFinal := MfString.Empty
		if(AddTabs = true)
		{
			tCount := GetTabCount()
			;~ MsgBox,,, Clipboard after tabcount:%clipboard%, 2
			; Select from the cursor position back to the start of the line so we can paste over it
			
			if (tCount > 0)
			{
				strFinal := Tabify(strSnip, tCount)
			} else {
				;send, {CtrlDown}l{CtrlUp}
				strFinal := strSnip
			}
		} else {
			strFinal := strSnip
		}
		Clip := ClipboardAll
		Clipboard =
		Sleep, 100
		if (ForceClear = true)
		{
			ForcedClear(TabCount)
		}
		Clipboard := strFinal
		Sleep, 100
		Send, ^v
		Sleep, 100
		;~ if (SendEscape) {
			;~ send, {esc}
		;~ }
		retval := true
		Clipboard := Clip
	} catch e {
		ex := new MfException(SnipyRI.Instance.GetResourceString("Exception_PasteSnipit", _m), e)
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
		;~ msg := ex.ToString()
		;~ MsgBox %msg%
		;~ SendErrorMessage(ex.ToString())
	} finally {
		
		Clip := Null
	}
	DebugLevel("{0} Finished", 1, A_ThisFunc)
	return retval
}
; End:PasteSnip ;}
;{ PasteSnipText
/*
	Function: PasteSnipText(funcParam)
		PasteSnipText() Paste Snippit text into code window
	Parameters:
		Text - The text to paste into the code window
		Method - Optional name of the method that is calling PasteSnip
		AddTabs - Optional if true the tabs are added to the start of the Snip Text. Default is True
		ForceClear - If true any text on the current line before the cursor wiped before inserting snippit
			This is usfule when autocomplete tries to complete a word from your hotstring.
	Returns:
		Returns true if no errors
	Throws:
		Throws MfException on general Errors
*/
PasteSnipText(Text, Method="", AddTabs=true, ForceClear=false) {
	DebugLevel("{0} Entered", 1, A_ThisFunc)
	DebugLevel("{0} Params - Text:'{1}' Method:'{2}' AddTabs:'{3}' ForceClear:'{4}'", 3
		, A_ThisFunc, Text, Method, AddTabs, ForceClear)
	retval := false
	if (Method)
	{
		_m := Method
	} else {
		_m := A_ThisFunc
	}
	clip := ""
	try {
		Clip := ClipboardAll
		tCount := 0
		if ((AddTabs = true) || (ForceClear = true))
		{
			tCount := GetTabCount()
		}
		if (ForceClear = true) {
			ForcedClear(TabCount)
		}
		if (AddTabs = true)
		{
			; Select from the cursor position back to the start of the line so we can paste over it
			send, {ShiftDown}{home}{ShiftUp}
				if (tCount > 0)
			{
				strFinal := Tabify(Text, tCount, ForceClear)
			} else {
				strFinal := Text
			}
		} else {
			strFinal := Text
		}
		
		Clipboard := strFinal
		Send, ^v
		Sleep, 200
		Clipboard := Clip
		;~ if (SendEscape) {
			;~ send, {esc}
		;~ }
		retval := true
		
	} catch e {
		ex := new MfException(SnipyRI.Instance.GetResourceString("Exception_PasteSnipit", _m), e)
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
		;~ msg := ex.ToString()
		;~ MsgBox %msg%
		;~ SendErrorMessage(ex.ToString())
	} finally {
		;~ Clipboard := Clip
		Clip := Null
	}
	DebugLevel("{0} Finished", 1, A_ThisFunc)
	return retval
}
; End:PasteSnipText ;}

;{ GetSnipText
/*
	Function: GetSnipText(snip)
		GetSnipText() Read the Snippit File and returns its contents
	Parameters:
		snip - The name of the snippit file to read in the form of NameOnly without extension
	Remarks:
		If **snip** is missing extension then .ahk is assumed
	Returns:
		Returns the contents of the snippit file
	Throws:
		Throws *MfExException* on any error
*/
GetSnipText(snip, hs) {
	if (MfString.IsNullOrEmpty(snip))
	{
		return MfString.Empty
	}
	retval := MfString.Empty
	try {
		if (Util.FileHasExt(snip))
		{
			strFileName := snip
		} else {
			strFileName := MfString.Format("{0}.snippit", snip)
		}
		
		strFile := MfString.Format("{0}\{1}", Script.Profile.PathSnips, strFileName)
		if (!FileExist(strFile))
		{
			ex := new MfFileNotFoundException(SnipyRI.Instance.GetResourceString("FileNotFoundException_Snipit"
				,strFileName, SnipitFolder, MfEnvironment.Instance.NewLine, hs), strFile)
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
		try {
			retval := Mfunc.FileRead(strFile)
		} catch ex {
			exx := new MfException(SnipyRI.Instance.GetResourceString("Exception_FileRead", A_ThisFunc), ex)
			exx.SetProp(strFile, A_LineNumber, A_ThisFunc)
			throw exx
		}
		
	} catch e {
		ex := new MfException(MfEnvironment.Instance.GetResourceString("Exception_Error", A_ThisFunc), e)
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
	return retval
}
; End:GetSnipText ;}
;{ SendErrorMessage
/*
	Function: SendErrorMessage(msg)
		SendErrorMessage() Send the error to the clipboard and paste it into active window
	Parameters:
		msg - The Error message
	Remarks:
		The is a general method to handle errors in the script. Since this script is not
		gui based and its output is expected in another text editor then this gives a
		way to display messages with details.
*/
SendErrorMessage(msg) {
	Clip := ClipboardAll
	Clipboard := msg
	Send, ^v
	Clipboard := Clip
	return
}

;{ DisplayError()
/*
	Function: DisplayError(e)
		DisplayError() Display error details
	Parameters:
		e - The error object or message to display
*/
DisplayError(e) {
	msg := MfString.Empty
	if (IsObject(e)) {
		if (MfObject.IsObjInstance(e, MfException))
		{
			msg := e.ToString()
		} else {
			ex := new MfException("Error", e)
			msg := ex.ToString()
		}
	} else {
		msg := ex
	}
	MsgBox, 16, Snippy Error!, %msg%
	return
}
; End:DisplayError() ;}
;{ GetTabCount
/*
	Function: GetTabCount(funcParam)
		GetTabCount() Gets the tab count from the start of the line to the cursor position in the code window
	Returns:
		Returns integer with the value of the tabs
	Throws:
		Throws MfException on general errors
*/
GetTabCount() {
	tabCount := 0
	try {
		Clip := ClipboardAll
		send, {ShiftDown}{home}{ShiftUp}
		; ctrl-L seems messy and can copy line breaks and other things.
		; does not seem like the best way to go
		;~ send, {CtrlDown}l{CtrlUp} ; ctrl L cuts the current line
		Sleep, 100
		 Send, ^c
		;~ send, {end}
		strLine := Clipboard
		;~ MsgBox strLINE:'%strLine%'
		strObj := new MfString(strLine)
		;~ msg := "'" . strObj.Value . "'"
		;~ MsgBox strLINE:%msg%
		strObj.Trim()
		if (!MfString.IsNullOrEmpty(strObj))
		{
			; if strLine is not null then we have chars other than whitechars on the line.
			; due the the wasy scite stop at the beginning of a line even if it
			; has tab char in front of it. For this reason we have to send the home key again.
			; Careful checking for this is necessary as scite will toggle between the begining of the
			; line and the beginning of the text on the line with the home key
			sleep, 100 ; give a little time just in case
			send, {ShiftDown}{home}{ShiftUp}
			Send, ^c
			strLine := Clipboard
		}
		send, {end}
		;~ MsgBox strLINE:'%strLine%'
		Clipboard := Clip
		Clip := Null
		strObj := Null
		tabCount := -1 ; extra tab is adde we parsing so start with -1
		Loop, Parse, strLine, `t
		{
			tabCount ++
		}
		if (tabCount = -1) {
			tabCount = 0
		}
		;~ MsgBox TabCount:'%tabCount%'
	} catch e {
		ex := new MfException(MfEnvironment.Instance.GetResourceString("Exception_Error", A_ThisFunc))
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
	return tabCount
}
; End:GetTabCount ;}
/*
	Function: ForcedClear(TabCount)
		ForcedClear() Clears the line of any text before the cursor.
	Parameters:
		TabCount - The current number of tab before any text on the cursor line
	Remarks:
		Clears text on the current line before the cursor.
		This is useful when autocomplete tries to complete a word from your hotstring.
	Throws:
		Throws MfException on any errors.
*/
ForcedClear(TabCount) {
	try {
		if (TabCount = 0)
		{
			return
		}
		
		strTab := MfString.Format("{Tab {0}}", TabCount)
		
		send, {ShiftDown}{home}{ShiftUp}
		; ctrl-L seems messy and can copy line breaks and other things.
		; does not seem like the best way to go
		;~ send, {CtrlDown}l{CtrlUp} ; ctrl L cuts the current line
		Sleep, 100
		 Send, ^c
		;~ send, {end}
		strLine := Clipboard
		;~ MsgBox strLINE:'%strLine%'
		strObj := new MfString(strLine)
		;~ msg := "'" . strObj.Value . "'"
		;~ MsgBox strLINE:%msg%
		strObj.Trim()
		if (!MfString.IsNullOrEmpty(strObj)) {
			; if strLine is not null then we have chars other than whitechars on the line.
			; due the the wasy scite stop at the beginning of a line even if it
			; has tab char in front of it. For this reason we have to send the home key again.
			; Careful checking for this is necessary as scite will toggle between the begining of the
			; line and the beginning of the text on the line with the home key
			sleep, 100 ; give a little time just in case
			send, {ShiftDown}{home}{ShiftUp}
			Sleep, 100
			Send, {BackSpace}
			Sleep, 100
			send, %strTab%
		}
	
	} catch e {
		ex := new MfException(MfString.Format(MfEnvironment.Instance.GetResourceString("Exception_Error"), A_ThisFunc), e)
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
}
;{ Tabify()
/*
	Function: Tabify(funcParam)
		Tabify() Adds tabs to the beginning each line of text
	Parameters:
		str - The String to add the tabs to
		TabCound - The number of tabs to add to the beginning of the string
		ForceClear - If true any text on the current line before the cursor wiped before inserting snippit
			This is useful when autocomplete tries to complete a word from your hotstring.
	Throws:
		Throws MfException on any general error
*/
Tabify(str, Tabcount=0, ForceClear=false) {
	if (MfString.IsNullOrEmpty(str))
	{
		return MfString.Empty
	}
	retval := MfString.Empty
	strTab := ""
	try {
		;~ MsgBox Tabify TabCout:%Tabcount%
		Loop, %Tabcount%
		{
			strTab .= "`t"
		}
		Clip := ClipboardAll
		send, {ShiftDown}{home}{ShiftUp}
		; ctrl-L seems messy and can copy line breaks and other things.
		; does not seem like the best way to go
		;~ send, {CtrlDown}l{CtrlUp} ; ctrl L cuts the current line
		sleep, 200
		 Send, ^c
		;~ send, {end}
		strLine := Clipboard
		strObj := new MfString(strLine)
		strObj.Trim()
		if (!MfString.IsNullOrEmpty(strObj))
		{
			; if strLine is not null then we have chars other than whitechars on the line.
			; due the the wasy scite stop at the beginning of a line even if it
			; has tab char in front of it. For this reason we have to send the home key again.
			; Careful checking for this is necessary as scite will toggle between the begining of the
			; line and the beginning of the text on the line with the home key
			sleep, 200 ; give a little time just in case
			send, {ShiftDown}{home}{ShiftUp}
			sleep, 200
			Send, ^c
			strObj.Value := Clipboard
			;~ msg := "'" . strObj.Value . "'"
			;~ MsgBox Not null line current value:%msg%
		}
		strObj.TrimEnd() ; if there are only tabs and line chars then strLine will be empty string
		if (MfString.IsNullOrEmpty(strObj))
		{
			;~ MsgBox null
			strLine := strTab
		} else {
			;~ MsgBox not null
			strLine := strObj.Value . " " ; add a space because we are appending to existing text on the line
		}
		Clipboard := Clip
		Clip := Null
		Count := 0
		Loop, Parse, str, `n
		{
			Count ++
			if ((Count = 1) && (ForceClear = false))
			{
				retval .= MfString.Format("{0}{1}", strLine, A_LoopField)
			} else {
				retval .= MfString.Format("{0}{1}", strTab, A_LoopField)
			}
			
		}
		if (MfString.IsNullOrEmpty(retval))
		{
			; if we have single line of text missed by the parse we will
			; handle it here
			retval .= MfString.Format("{0} {1}", strLine, A_LoopField)
		}
	} catch e {
		ex := new MfException(MfString.Format("[{0}] Error", A_ThisFunc), e)
		ex.Source := A_ThisFunc
		ex.File := A_LineFile
		ex.Line := A_LineNumber
		throw ex
	}
	return retval
}
;{ Script Message
; 	End:SendSuspendTimoutMessage() ;}
GetSnippitInlineText(strFileName)
{
	varCode := ""
    varSnipFile := MfString.Format("{0}\{1}", Script.Profile.PathSnipsInline, strFileName)
    if (FileExist(varSnipFile))
    {
        varCode := Mfunc.FileRead(varSnipFile)
    }
    return varCode
}
;{ 	Message Methods
;{		Receive_WM_COPYDATA()
/* 
 * ======================================================================================================================================================
	Function to Receive messages.
 * ======================================================================================================================================================
 */
Receive_WM_COPYDATA(wParam, lParam) {
	global CancelSent
	retval := true
	try {
		StringAddress := NumGet(lParam + 2*A_PtrSize)  ; Retrieves the CopyDataStruct's lpData member.
		CopyOfData := StrGet(StringAddress)  ; Copy the string out of the structure.
		Debug("{0}: Message Received:'{1}'", A_ThisFunc, CopyOfData)
		; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
		if (CopyOfData = "Reload")
		{
			Debug("[{0}].[{1}.{2}] Message recieved:'{3}'", Script.ThisScriptName, "AhkSnippy", A_ThisFunc, "Reload")
			Gosub, ScriptReload
		}
	} catch e {
		ex := new ExException(String.Format("[{0}] Error", A_ThisFunc), e)
		ex.Source := A_ThisFunc
		ex.File := A_LineFile
		ex.Line := A_LineNumber
		Debug(ex.ToString())
		retval := false		
	}
	Debug("[{0}] is returning a value of:{1}. True is Success and False is failure.", A_ThisFunc, MfBool.GetValue(retval))
    return retval  ; Returning 1 (true) is the traditional way to acknowledge this message.
}
;		End:Receive_WM_COPYDATA() ;}
;{		SendMainMessage()
/* 
 * ======================================================================================================================================================
	Sends a message to the target script
 * ======================================================================================================================================================
 */
SendMainMessage(strText, TargetScriptTitle) {
	result := Send_WM_COPYDATA(strText, TargetScriptTitle)
	if (result = FAIL)
	{
		Debug("[{0}].[{1}] Send Messsage'{2}' failed to target:'{3}'", Script.ThisScriptName, A_ThisFunc, strText, TargetScriptTitle)
		return false
	} else if (result = 0) {
		Debug("[{0}].[{1}] Send Messsage'{2}' success to target:'{3}'", Script.ThisScriptName, A_ThisFunc, strText, TargetScriptTitle)
		return true
	}
}
;		End:SendMainMessage() ;}
;{		Send_WM_COPYDATA()
	; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle) {
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  ; 0x4a is WM_COPYDATA. Must use Send not Post.
    DetectHiddenWindows %Prev_DetectHiddenWindows%  ; Restore original setting for the caller.
    SetTitleMatchMode %Prev_TitleMatchMode%         ; Same.
    return ErrorLevel  ; Return SendMessage's reply back to our caller.
}
; End:Script Message ;}
;{ 	ScriptReload - Reloads the current script
ScriptReload:
Reload
return

DisplayHotlist:
try {
	hotlist := Script.conf.AppHotList
	run, %hotlist%
} catch e {
	DebugError(e, 1, A_ScriptName, A_LineNumber)
	HandleError(e)
}
hotlist =
return

DisplayProfileSwap:
try {
	swap := Script.conf.AppSwap
	run, %swap%
} catch e {
	DebugError(e, 1, A_ScriptName, A_LineNumber)
	HandleError(e)
}
swap =
return
; Exit function to update ini state to reflect script is not running
ExitFunc(ExitReason, ExitCode)
{
	; save the App settings to update the script path and running state
	aSet := new AppSettings()
	aSet.ScriptLoaded := 0
	aSet.Save()
	aSet := Null
    return 0
    ; Do not call ExitApp -- that would prevent other OnExit functions from being called.
}
;{ 	ScriptExit
ScriptExit:
ExitApp
; End:ScriptExit ;}
;{ 	ScriptExit
RunSpy:
Run, %winspy%
return

PauseScript:
sResource := Script.Res.GetResourceStringBySection("Pause", "GUI")
if(A_IsPaused)
{
	Menu, tray, UnCheck, %sResource%
	Pause, Off
	;Menu, tray, icon, %A_ScriptDir%\icons\icon.ico
	return
}
else
{
	Menu, tray, Check, %sResource%
	Pause, On
	;Menu, tray, icon, %A_ScriptDir%\icons\pause.ico
	return
}

sResource := Null
return

SuspendScript:
sResource := Script.Res.GetResourceStringBySection("Suspend", "GUI")
if(A_IsSuspended)
{
	Menu, tray, UnCheck, %sResource%
	Suspend, Off
	return
	;Menu, tray, icon, %A_ScriptDir%\icons\suspend.ico
}
else
{
	Menu, tray, Check, %sResource%
	Suspend, On
	return
	;Menu, tray, icon, %A_ScriptDir%\icons\suspend.ico
}

ShowHelp:
{
	sResource := A_ScriptDir
	sResource := sResource . "\" . Script.Res.GetResourceStringBySection("FileHelp", "GUI")
	if(FileExist(sResource))
	{
		RunOrActivate("hh.exe", "AutoHotkey Snippit", Null, Null, sResource, false)
	}
	else
	{
		sResource := Script.Res.GetResourceString("FileNotFoundException_HelpFile")
		sTitle := Script.Res.GetResourceString("FileNotFound_title")
		MsgBox, 48, %sTitle%, %sResource%
		sTitle := Null
	}
	sResource := Null
	return
}
Donate:
{
	Run, http://tiny.cc/snipdonate/
	return
}

sResource := Null
return

; End:ScriptExit ;}
; End:ScriptReload ;}
#include <Inc_cInputBox>
#include <Inc_cInputList>
#Include <Inc_HandleError>
#if (WhiteList.GetWindowActive())
#include *i %A_AppData%\AutoHotkey Snippit\plugins\ ; so the paths can be relative in the plugins.ahk
#include *i %A_AppData%\AutoHotkey Snippit\plugins.ahk ; *i so the file can be non-existant
#include *i %A_AppData%\AutoHotkey Snippit\pluginHs.ahk ; *i so the file can be non-existant
#include *i %A_AppData%\AutoHotkey Snippit\pluginKeys.ahk ; *i so the file can be non-existant