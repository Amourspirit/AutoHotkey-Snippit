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


; Contains functions and globals that are for public use in plugins and includes

global Null := "" ; null super global
global BO := Chr(123) ; Brace Open
global BC := Chr(125) ; Brace Close
global UBO := "{U+007B}" ; Open code brace {
global UBC := "{U+007D}" ; Close Code Brace }

;{    RunOrActivate
   /*!
   Function: RunOrActivate()
      RunOrActivate() Run a program or switch to it if already running.
   Parameters:
         Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
         WinTitle - Optional title of the window to activate.  Programs like
            MS Outlook might have multiple windows open (main window and email
            windows).  This parm allows activating a specific window.
*/
RunOrActivate(Target, WinTitle = "", WorkingDir = "", Options = "", Params = "", ShowTrayTip=true)
{
   ; Get the filename without a path
   SplitPath, Target, TargetNameOnly

   Process, Exist, %TargetNameOnly%
   If ErrorLevel > 0
      PID = %ErrorLevel%
   Else
      Run, %Target% "%Params%", %WorkingDir%, %Options%, PID

   ; At least one app (Seapine TestTrack wouldn't always become the active
   ; window after using Run), so we always force a window activate.
   ; Activate by title if given, otherwise use PID.
   If WinTitle <>
   {
      SetTitleMatchMode, 2
      WinWait, %WinTitle%, , 3
      if(ShowTrayTip)
      {
         sResource := Script.Res.GetResourceStringBySection("TrayTip_Active_Win_Title", "GUI")
         sTip := MfString.Format(sResource, WinTitle, TargetNameOnly)
         TrayTip, , %sTip%
         sTip := Null
         sResource := Null
      }
      
      WinActivate, %WinTitle%
   }
   Else
   {
      WinWait, ahk_pid %PID%, , 3
      if(ShowTrayTip)
      {
         sResource := Script.Res.GetResourceStringBySection("TrayTip_Active_Win_Pid", "GUI")
         sTip := MfString.Format(sResource, PID, TargetNameOnly)
         TrayTip, , %sTip%
         sTip := Null
         sResource := Null
      }
      WinActivate, ahk_pid %PID%
   }
}
; End:RunOrActivate ;}

; End:SendErrorMessage ;}
;{ GetClipboardData()
GetClipboardData(Restore = true) {
   return Public.GetClipboardData(Restore)
}
; End:GetClipboardData() ;}
Class Public
{
;{ ExplorePath()
   ; Opens explore to a specific path. path tokes are accepted
/*
   Method: ExplorePath()

   ExplorePath()
      Open Explorer to a path
   Parameters:
      sPath
         The file/folder path to nagigate Explorer too.
   Remarks:
      if sPath is not found then Explorer is opened to default location
*/
   ExplorePath(sPath) {
      if(MfString.IsNullOrEmpty(sPath)) 
      {
          run, explorer.exe
          return
      }

      strPath := MfString.GetValue(sPath)
      strPath := Public.ReplacePathTokens(strPath)
      ;strPath := MfString.Escape(strPath)
      if(FileExist(strPath))
      {
         run, explorer.exe "%strPath%"
      }
      else
      {
         run, explorer.exe
      }
   }
; End:ExplorePath() ;}
;{ GetClipboardData()
/*
   Method: GetClipboardData()

   GetClipboardData()
      Copies Selected Text to the clipboard and returns the value.
      Optionally restores the original clipboard value
   Parameters:
      Restore
         If True (default) then the original clipboard value will be restored
   Returns:
      Returns the slected text
*/
   GetClipboardData(Restore = true) {
      ClipSaved := ""
      if (Restore) {
         ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable to replace later
      }
      
      Send, ^c
      Sleep, 200
      retval := clipboard
      if (Restore) {
         Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
         ClipSaved =   ; Free the memory in case the clipboard was very large.
      }
      
      return retval
   }
; End:GetClipboardData() ;}
;{ ReplacePathTokens()
   ; replaces Path varaibles such as %documents% with actual path.
   ; if MfString is passed in then a MfString will be returned.
/*
   Method: ReplacePathTokens()

   ReplacePathTokens()
      Replaces any tokes in a string with the values from the current enviromnemtn
   Parameters:
      str
         The string to replace the token in
   Returns:
      Returns str with any revelant tokens replace with environment
   Throws:
      Throws MfArgumentNullException if str is null or empty
*/
   ReplacePathTokens(str) {
      if(MfString.IsNullOrEmpty(str))
      {
         ex := new MfArgumentNullException("str")
         ex.SetProp(A_ScriptName, A_LineNumber, A_ThisFunc)
         throw ex
      }
      IsMfString := false
      if(MfObject.IsObjInstance(str, MfString))
      {
         IsMfString := true
      }
      regx := "i)^%[a-z]+%.*"
      s := MfString.GetValue(str)
      Matched := false
      if(s ~= regx)
      {
         regx := "i)^%[a-z]+"
         StringReplace, s, s, `%MyDocuments`%, %A_MyDocuments%, 1
         FoundPos := RegExMatch(s, regx)
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%ProgramFiles`%, %A_ProgramFiles%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%Documents`%, %A_MyDocuments%, 1
            FoundPos := RegExMatch(s, regx)
         }
         
         
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%AppData`%, %A_AppData%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%PublicAppData`%, %A_AppDataCommon%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%Desktop`%, %A_Desktop%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%DesktopCommon`%, %A_DesktopCommon%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%PStartMenu`%, %A_StartMenu%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%PublicStartMenu`%, %A_StartMenuCommon%, 1
            FoundPos := RegExMatch(s, regx)
         }

         if(FoundPos > 0)
         {
            StringReplace, s, s, `%Programs`%, %A_Programs%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%ProgramsCommon`%, %A_ProgramsCommon%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%Startup`%, %A_Startup%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%StartupCommon`%, %A_StartupCommon%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%WinDir`%, %A_WinDir%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            StringReplace, s, s, `%Temp`%, %A_Temp%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.UserPictures
            StringReplace, s, s, `%Pictures`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.UserMusic
            StringReplace, s, s, `%Music`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.UserVideo
            StringReplace, s, s, `%Video`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.UserStartup
            StringReplace, s, s, `%Startup`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }

         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.UserAppDataRoaming
            StringReplace, s, s, `%AppDataRoaming`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.CommonPictures
            StringReplace, s, s, `%PublicPictures`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.CommonMusic
            StringReplace, s, s, `%PublicMusic`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.CommonVideo
            StringReplace, s, s, `%PublicVideo`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
         if(FoundPos > 0)
         {
            env := MfEnvironment.Instance.CommonAppData
            StringReplace, s, s, `%PublicAppData`%, %env%, 1
            FoundPos := RegExMatch(s, regx)
         }
      }
     
      retval := Null
      if(IfMfString)
      {
         retval := new MfString(s)
         retval.ReturnAsObject := str.ReturnAsObject
      }
      else 
      {
         retval := s
      }
      return retval
   }
; End:ReplacePathTokens() ;}
;{ GetFirstLineOnly()
/*
   Method: GetFirstLineOnly()

   GetFirstLineOnly()
      Gets the First Line of MultiLine String
   Parameters:
      strInput
         Input String
   Returns:
      Returns First Line of Mulitline string or strInput if single line
   Remarks:
      If strInput is single line then it is returned
*/
   GetFirstLineOnly(strInput) {
      Loop Parse, strInput, `n, `r  ; Remove linebreaks
      {
         if StrLen(A_LoopField) > 0 then
         {
            strInput := A_LoopField
            break
         }
      }
      return strInput
   }
; End:GetFirstLineOnly() ;}
;{ GetLastLineOnly()
/*
   Method: GetLastLineOnly()

   GetLastLineOnly()
      Gets the Last Line of MultiLine String
   Parameters:
      strInput
         Input String
   Returns:
      Returns Last Line of Mulitline string or strInput if single line
   Remarks:
      If strInput is single line then it is returned
*/
   GetLastLineOnly(strInput) {
      Loop Parse, strInput, `n, `r  ; Remove linebreaks
      {
         if StrLen(A_LoopField) > 0 then
         {
            strInput := A_LoopField
          }
      }
      return strInput
   }
; End:GetLastLineOnly() ;}
}
