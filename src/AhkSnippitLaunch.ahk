;{ License
/* Copyright (C) 2014-2017  Paul Moss
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


#SingleInstance force
#NoEnv
#Persistent
#NoTrayIcon 

Global LanguagePack := "en-US" ; set the default language for Resource Files
Global ResFile := A_ScriptDir . "\Resource\Resource_Core_" . LanguagePack . ".dll"

#Include <Inc_Script>

; Installer now checks for correct Mini-Framework is installed so check here is no longer necessary
; include Mini Framework optionally so we can test if it is installed
;~ #Include *i <inc_mf_000200>


;~ ; test to see if the Mini-Framwork is installed
;~ if(!IsFunc("inc_mf_000200"))
;~ {
 ;~ msg := GetResourceString("Msg_Missing_Mini_Framework")
 ;~ StringReplace, msg, msg, {0}, 0.2.0, All
 ;~ msg .= "`n"
 ;~ msg .= GetResourceString("Msg_Scrip_Will_Now_Exit")
 ;~ msgTitle := GetResourceString("Msg_Missing_Mini_Framework_Title")
 ;~ MsgBox, 16, %msgTitle%, %msg%
 ;~ ExitApp
;~ }


AppDataPath := A_AppData . "\" . Script.DataFolder
iniAppFile := AppDataPath . "\app.ini"
iniSettingsFile := AppDataPath . "\settings.ini"

IniRead, LaunchPath, %iniAppFile%, SCRIPT, LaunchPath

if ((LaunchPath != A_ScriptFullPath) && (!FileExist(LaunchPath))) {
  IniWrite, %A_ScriptFullPath%, %iniAppFile%, SCRIPT, LaunchPath
  LaunchPath := A_ScriptFullPath
}

ForceStart := false
NoWrite := false
LaunchPath := ""
Loop, %0%  ; For each parameter:
{
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    if (param ~= "i)[-/][a-z]")
    {
      StringReplace, param, param, -,, All
      StringReplace, param, param, /,, All
      StringReplace, param, param, \,, All
      if (param = "forcestart")
      {
        ForceStart := true
      }
      if (param = "nowrite")
      {
        NoWrite := true
      }
    }
}


IniRead, MainScriptFile, %iniAppFile%, SCRIPT, MainScriptFile
MainScript := MainScriptFile . " ahk_class AutoHotkey"


IniRead, PluginWriter, %iniSettingsFile%, APPS, writer
iniHasPath := true
if(!FileExist(PluginWriter))
{
 PluginWriter := A_ScriptDir . "\bin\PluginWriter.exe"
 iniHasPath := false
}

if(!FileExist(PluginWriter))
{
 PluginWriter := A_ProgramFiles . "\" . Script.DataFolder . "\PluginWriter.exe"
}

MainScriptFullPath := A_ScriptDir . "\" . MainScriptFile
if(!FileExist(MainScriptFullPath))
{
 MainScriptFullPath := A_ProgramFiles . "\" . Script.DataFolder . "\AhkSnippyTool.ahk"
}

if(!FileExist(MainScriptFullPath))
{
; error
  msg := GetResourceString("Error_mainscript_not_found_msg")
  msg .= "`n"
  msg .= GetResourceString("Msg_Scrip_Will_Now_Exit")
  msgTitle := GetResourceString("Error_mainscript_not_found_title")
  MsgBox, 16, %msgTitle%, %msg%
 ExitApp
}

if(!FileExist(PluginWriter))
{
 ; error
  msg := GetResourceString("Error_pluginwriter_not_found_msg")
  msg .= "`n"
  msg .= GetResourceString("Msg_Scrip_Will_Now_Exit")
  msgTitle := GetResourceString("Error_pluginwriter_not_found_title")
  MsgBox, 16, %msgTitle%, %msg%
 ExitApp
}

if(iniHasPath = false)
{
 IniWrite, %PluginWriter%, %iniSettingsFile%, APPS, writer
}
iniHasPath := ""

if (NoWrite = false)
{
  ; run the plugin writer to write all the hotkey, hotstring, and includes for the current profile
  RunWait, %PluginWriter%, ,Hide
  ;RunWait, %PluginWriter%
}




; clean up any previous err files

ErrPattern := AppDataPath . "\*.err"
FileDelete, %ErrPattern%

; attempt to read the results of the plugin writer from the ini

if(!FileExist(iniAppFile))
{
 IniWrite, %A_ScriptFullPath%, %iniAppFile%, WRITER, path
 IniWrite, 0, %iniAppFile%, WRITER, exitcode
}

IniRead, ReloadResult, %iniAppFile%, WRITER, exitcode


if ReloadResult is integer
{
 if(ReloadResult > 0)
 {
  ; if there is an error then rename the plugins include files to avoid script startup issues.
  ; renaming will give an chance to review the files for errors if needed.

  ; an error has occured
  PluginFiles := AppDataPath . "\Plugins.ahk"
  PluginHs := AppDataPath . "\PluginHs.ahk"
  PluginKeys := AppDataPath . "\PluginKeys.ahk"
  PluginEndChars := AppDataPath . "\endchars.ahk"
  
  if(FileExist(PluginFiles))
  {
   Dest := AppDataPath . "\Plugins.err"
   FileCopy,%PluginFiles%, %Dest%, 1
   Dest := ""
   FileDelete, %PluginFiles%
  }
  if(FileExist(PluginHs))
  {
   Dest := AppDataPath . "\PluginHs.err"
   FileCopy,%PluginHs%, %Dest%, 1
   Dest := ""
   FileDelete, %PluginHs%
  }
  if(FileExist(PluginKeys))
  {
   Dest := AppDataPath . "\PluginKeys.err"
   FileCopy,%PluginKeys%, %Dest%, 1
   Dest := ""
   FileDelete, %PluginKeys%
  }
  if(FileExist(PluginEndChars))
  {
   Dest := AppDataPath . "\endchars.err"
   FileCopy,%PluginEndChars%, %Dest%, 1
   Dest := ""
   FileDelete, %PluginEndChars%
  }
  
  ; if the exit code is greater then zero then an error has occured
  ; alert the user of the error code
  msg := GetResourceString("Error_unable_to_load_profile_code")
  StringReplace, msg, msg, {0}, %ReloadResult%, All
  msg .= "`n"
  msg .= GetResourceString("Msg_Scrip_Will_Now_Exit")
  msgTitle := GetResourceString("Error_unable_to_load_profile_Title")
  MsgBox, 16, %msgTitle%, %msg%
  ExitApp
 }
 ; exit code of -100 is reload required
 ;~ MsgBox ExitResult: %ReloadResult%
 if(ReloadResult = -100)
 {
  ; send a message to the main script if it is running to reload.
  SendMainMessage("Reload", MainScript)
 }
}

if (ForceStart = true)
{
  ; run the main script which will force a restart if it is alredy running
  Run, %MainScriptFullPath%
}
ExitApp

; get resource value from the resource file
GetResourceString(key, Section="CORE")
{
 result := ""
 IniRead, result, %ResFile%, %Section%, %key%
 if (result = "ERROR") {
  result := ""
 }
 return result
}

;{  Message Methods
;{    SendMainMessage()
/* 
 * ======================================================================================================================================================
  Sends a message to the target script
 * ======================================================================================================================================================
 */
SendMainMessage(strText, TargetScriptTitle) {
 result := Send_WM_COPYDATA(strText, TargetScriptTitle)
 if (result = FAIL)
 {
  return false
 } else if (result = 0) {
  return true
 }
}
;   End:SendMainMessage() ;}
;{    Send_WM_COPYDATA()
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle)  ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
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
;   End:Send_WM_COPYDATA() ;}
;   End:Message Methods ;}