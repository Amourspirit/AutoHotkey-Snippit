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
;#Include <Inc_MiniFramework>
#Include <Class_ErrorBoxResult>
/*
	Scripts using this include will need to have the following ini section in it resource section.
	As well the scritp using this include will need to have Script.Res set in an instance of MfResourceSingletonBase
	
	[HANDLEERROR]
	App_Exit={0}{1}Application will exit!
	Btn_OK=&OK
	Btn_OK_Clean=OK
	Btn_Details=&View Details
	Btn_Details_Clean=View Details
	Btn_No=&No
	Btn_No_Clean=No
	Btn_Yes=&Yes
	Btn_Yes_Clean=Yes
	Btn_Copy_To_Clip=Copy to Clipboard
	Btn_Save_As_File=Save as file
	Btn_Close=Close
	Save_to_File_Title=Create File
	Save_to_File_Type=Text Documents (*.txt)
	Error_Generated_From=Generated from script:{0}
	Error_General_Title=Error
	Error_Critical=Critical Error
	Error_Critical_Name={0} - Critical Error
	Error_Occurred=An error has occurred.
	Error_ExitApp=A critical error has occured and I am not able to handle it.{0}I am closing down now.
	Error_ExitApp_NoSave=An error has occured while attempting to save to file.{0}This error cannot be saved at this time.{0}The Application will now exit.
	To_Clipboard_Title=Error Copied
	To_Clipboard_Msg=The Error details have been copied to the clipboard
	To_File_Title=Error Save
	To_File_Msg=Error has been saved.
*/
; TODO: Entend methods to include and execute links to help.
; TODO: Localize string into resource file
;{	Library Text
/*!
	Library: Inc_HandleError
		This Library contains varisous methods for Displaying and saving Errors.  
		This Library is required to be included in your main script.  
		It is recommended if you include this script at the end of your
		main script. This script contains lables with return statements. Including this script
		to earily in your main script may cause your script to hang. Do not include before the first
		*return* is hit in your main script.
	Author: Paul Moss
	License: Free WTFL
	Version: 1.0
*/
;	End:Library Text ;}
;{	Page: Usage
/*!
	Page: Usage
	Filename: Handle_Error_Usage
	Contents:
		# Usage Example
		Your main script will only need call [HandleError](HandleError.html).
		
		## Example
		> MyFirstFunction(DoFirstThing) {
		> 	retval := true
		> 	try {
		> 			; some code here this may generate an error
		> 	} catch e {
		> 		ex := new MfException(MfString.Format("[{0}] Error", A_ThisFunc), e)
		> 		ex.Source := A_ThisFunc
		> 		ex.File := A_LineFile
		> 		ex.Line := A_LineNumber
		> 		Throw ex
		> 	}
		> 	return retval
		> }
		Use [HandleError](HandleError.html) below to display the error with options to save the error.
		> MyFunction(DoSometing) {
		> 	retval := true
		> 	try {
		> 		; some code here this may generate an error
		> 	} catch e {
		> 		ex := new MfException(MfString.Format("[{0}] Error", A_ThisFunc), e)
		> 		ex.Source := A_ThisFunc
		> 		ex.File := A_LineFile
		> 		ex.Line := A_LineNumber
		> 		HandleError(ex,"","", false) ; handle error and continue. Error info will be displad for both the error in MyFirstFunction and the Error in MyFunction
		> 		retval := false
		> 	}
		> 	return retval
		> }
		Or use this method if you do not wish to add extra exception info the the error
		> MyFunction(DoSometing) {
		> 	retval := true
		> 	try {
		> 		; some code here this may generate an error
		> 	} catch e {
		> 		HandleError(e,"","", false) ; handle error and continue. Error info will be displad for the Error in MyFirstFunction
		> 		retval := false
		> 	}
		> 	return retval
		> }
*/
;	End:Page: Usage ;}


;{	CErrorToFile
/*!
	Function: CErrorToFile(Text)
		CErrorToFile() Creates and/or appends text to a file
	Parameters:
		Text - The text to append to the file selected
	Remarks:
		This method prompts the user for a filename to save to.
		If the user selects and existing file the text will be appended to it.
		Otherwise a new file is created. If the user creates a file without an extension then
		the txt extension is automatically added to it.
	Returns:
		Returns 1 on successful write. Will return 0 if *Text* param is null or user cancels operation.
	Extra:
		This method is intende to be used to write Errors to a text file. This method
		formats the text before writing to a file.
	Throws:
		Throws ExException on General Error
*/
CErrorToFile(Text) {
	try {
		if (MfString.IsNullOrEmpty(Text)) {
			return 0
		}
		CurrentDateTime := Mfunc.FormatTime("","yyyy-MM-dd-hh-mm-ss")
		strName := new SMftring(MfString.Empty)
		if (script.Name) {
			strName.Append("-")
			strName.Append(script.Name)
		}
		RootDir := MfString.Format("{0}\{1}-Error{2}.txt", A_MyDocuments, CurrentDateTime, strName)
		TextFile := Mfunc.FileSelectFile("s3"
			, RootDir
			, Script.Res.GetResourceStringBySection("Save_to_File_Title", "HANDLEERROR")
			, Script.Res.GetResourceStringBySection("Save_to_File_Type", "HANDLEERROR"))
		if (MfString.IsNullOrEmpty(TextFile)) {
			return 0
		}
		SplitPath, TextFile,fName,fPath,fext
			
		if (MfString.IsNullOrEmpty(fext)) {
			TextFile .= ".txt"
		}
		
		strText := new MfString(MfString.Empty)
		if (FileExist(TextFile)) {
			;FileDelete(TextFile)
			strText.AppendLine()
		}
		strText.AppendLine("=================================================")
		if (script.Name) {
			strText.AppendLine(Script.Res.GetResourceStringBySection("Error_Generated_From", "HANDLEERROR", Script.Name))
		}
		CurrentDateTime := Mfunc.FormatTime("","yyyy.MM.dd.hh.mm.ss")
		strText.AppendLine(CurrentDateTime)
		strText.AppendLine(Text)
		strWrite := strText.Value
		Mfunc.FileAppend(strWrite, TextFile, "UTF-8")
	} catch e {
		ex := new MfException(MfEnvironment.Instance.GetResourceString("Exception_Error", A_ThisFunc))
		ex.Source := A_ThisFunc
		ex.File := A_LineFile
		ex.Line := A_LineNumber
		throw ex
	}
	return 1
	
}
;	End:CErrorToFile ;}
;{ HandleError
/*!
	Function: HandleError(err, errTitle="", errMsg="", ForceExit=false)
		HandleError() Handles errors by displaying a message box with option to show and save detailed error messages
	Parameters:
		err - The error to save. This can be an *Object* that Derives From *ExException* or a string var containing error message.  
		errTitle - Optional. The Title to show in the Error Message dialog. Defaults to *Critical Error* if omitted.  
		errMsg - Error Message to display in the Error Message dialog. Defaults to "An Error Has Occured"
			if *err* is a var or `err.Message` if err is *ExException*  
		forceExit - Boolean value. If `true` then application will exit after error is handled. Also
			*Application will exit!* is appended to the Message displayed.  
		buttons - Pipe-separated list of buttons. Putting an asterisk in front of a button will make it the default.  
		icon - If blank, we will use an Error icon. If a number, we will take this icon from Shell32.dll
			If a letter ("I", "E" or "Q") we will use some predefined icons from Shell32.dll (Info, Error or Question).  
		 owner - If 0, this will be a standalone dialog. If you want this dialog to be owned by another GUI, place its number here.
	Remarks:
		If an error occurs within this method then a dialog is displayed and the application is terminated.
*/
HandleError(err, errTitle="", errMsg="", forceExit=false, owner=0, buttons="", icon="") {
	retval := ""
	try {
		strErr := ""
		if (MfObject.IsObjInstance(err, MfException)) {
			strErr := err.ToString()
		} else if (IsObject(err)) {
			strErr := err.Message
		}
		;~ Debug(strErr)
		if (MfString.IsNullOrEmpty(errTitle)) {
			displayTitle := Script.Res.GetResourceStringBySection("Error_Critical", "HANDLEERROR")
		} else {
			displayTitle := errTitle
		}
		if (MfString.IsNullOrEmpty(errMsg)) {
			displayMsg := Script.Res.GetResourceStringBySection("Error_Occurred", "HANDLEERROR")
		} else {
			displayMsg := errMsg
		}
		if (forceExit) {
			displayMsg := Script.Res.GetResourceStringBySection("App_Exit", "HANDLEERROR", displayMsg, MfEnvironment.Instance.NewLine)
		}
		if (MfString.IsNullOrEmpty(buttons)) {
			_buttons := MfString.Format("*{0}|{1}"
				, Script.Res.GetResourceStringBySection("Btn_OK", "HANDLEERROR")
				, Script.Res.GetResourceStringBySection("Btn_Details", "HANDLEERROR")) ; "*&OK|&View Details"
		} else {
			_buttons := buttons
		}
		if (MfString.IsNullOrEmpty(icon)) {
			_icon := "E"
		} else {
			_icon := icon
		}
		Pressed := CMsgBoxErr( displayTitle, displayMsg, _buttons, _icon, owner)
		retval := Pressed
	} catch e {
		ex := new MfException(MfEnvironment.Instance.GetResourceString("Exception_Error", A_ThisFunc))
		ex.Source := A_ThisFunc
		ex.File := A_LineFile
		ex.Line := A_LineNumber
		throw ex
		msg := ex.ToString()
		MsgBox, 8208, Critical Error, %msg%
		msg := MfString.Format("A critical error has occured and I am not able to handle it.{0}I am closing down now."
		, MfEnvironment.Instance.NewLine)
		msgTitle := Script.Res.GetResourceStringBySection("Error_Critical_Name", "HANDLEERROR", script.Name)
		MsgBox, 8208, %msgTitle%, %msg%
		ExitApp
	}
	_btnViewDetails := Script.Res.GetResourceStringBySection("Btn_Details_Clean", "HANDLEERROR")
	_btnYes := Script.Res.GetResourceStringBySection("Btn_Yes_Clean", "HANDLEERROR")
	_btnNo := Script.Res.GetResourceStringBySection("Btn_No_Clean", "HANDLEERROR")
	
	if ((Pressed = _btnViewDetails) || (Pressed = _btnYes) || (Pressed = _btnNo)) {
		try {
			if (MfObject.IsObjInstance(err, MfException)) {
				ErrBoxResult := cErrorBox(err)
			} else if (IsObject(err)) {
				ErrBoxResult := cErrorBox(strErr, "", displayTitle, owner)
			}
		} catch e {
			ex := new MfException(MfEnvironment.Instance.GetResourceString("Exception_Error", A_ThisFunc))
			ex.Source := A_ThisFunc
			ex.File := A_LineFile
			ex.Line := A_LineNumber
			throw ex
			msg := ex.ToString()
			MsgBox, 8208, Critical Error, %msg%
			msg := Script.Res.GetResourceStringBySection("Error_ExitApp", "HANDLEERROR", MfEnvironment.Instance.NewLine)
			msgTitle := Script.Res.GetResourceStringBySection("Error_Critical_Name", "HANDLEERROR", Script.Name)
			MsgBox, 8208, %msgTitle%, %msg%
			ExitApp
		}
		
		if (ErrBoxResult.Value = ErrorBoxResult.Instance.ToClipBoard.Value) {
			;msg := "Asking to copy to clipboard"
			Clipboard := strErr
			msgTitle := Script.Res.GetResourceStringBySection("To_Clipboard_Title", "HANDLEERROR")
			msg := Script.Res.GetResourceStringBySection("To_Clipboard_Msg", "HANDLEERROR")
			MsgBox, 8256, %msgTitle%, %msg%, 3
		}
		if (ErrBoxResult.Value = ErrorBoxResult.Instance.ToFile.Value) {
			try {
				ToFileResult := CErrorToFile(err.ToString())
				if (ToFileResult = 1) {
					msgTitle := Script.Res.GetResourceStringBySection("To_File_Title", "HANDLEERROR")
					msg := Script.Res.GetResourceStringBySection("To_File_Msg", "HANDLEERROR")
					MsgBox, 8256, %msgTitle%, %msg%, 3
				}
			} catch e {
				msg := Script.Res.GetResourceStringBySection("Error_ExitApp_NoSave", "HANDLEERROR", MfEnvironment.Instance.NewLine)
				msgTitle := Script.Res.GetResourceStringBySection("Error_Critical", "HANDLEERROR")
				MsgBox, 8208, Critical Error, %msg%
				ExitApp
			}
			
		}
	}
	if (ForceExit) {
		ExitApp
	}
	return retval
}
; End:HandleError ;}
;{ 	cErrorBox
/*!
	Function: cErrorBox(ErrorMsg) or cErrorBox(ErrorMsg, Title) or cErrorBox(ErrorMsg, Title, WindowTitle) or cErrorBox(ErrorMsg, Title, WindowTitle, Owner)
		cErrorBox() Generates a gui that displays Error Info Details
	Parameters:
		ErrorMsg - This is the error to display in the main window. This can be a var contaning text or any object that inherits from ExExecption Object
		Title - Optional. The Title to show above the Error Display. Defaults to `Error.Message` if omitted.
		WindowTitle - Optional. The Title of the window tilebar. Defaults to *Title* if omitted.
		Owner - Optional. If 0, this will be a standalone dialog. If you want this dialog to be owned by another GUI, place its number here.
	Remarks:
		This method requires the Miniframework libraries by Paul Moss.  
		This method also requires <Class_ErrorBoxResult> Include
	Returns:
		Returns an Instance of ErrorBoxResult
	Throws:
		Throws stuff
	Example:
		> ex := new ExException(Error has occurred") ; Generate new Execption from MiniFramework Library
		> ex.Source := A_ThisFunc
		> ex.File := A_LineFile
		> ex.Line := A_LineNumber
		> 
		> ; Generate Error Message box from myError.
		> ; retval will be an instance of ErrorBoxResult Enum
		> retval := cErrorBox(myError) ; Call cErrorBox to display the error
		> if (retval.Value = ErrorBoxResult.Instance.ToClipBoard.Value) {
		> ; retval value is ToClipboard so copy error to clipboard
		> 	Clipboard := myError.ToString()
		> }
		> if (retval.Value = ErrorBoxResult.Instance.ToFile.Value) {
		> 	; Asking to save to File to lets get started
		> 	try {
		> 		CErrorToFile(myError.ToString()) ; Call CErrToFile to Save myError.ToString() value to a text file
		> 	} catch e {
		> 		; Critical error, unable to handle gracefully, create MsgBox, display error, exit app
		> 		strMsg := new String("An error has occured while attempting to save to file.")
		> 		strMsg.AppendLine("This error cannot be saved at this time.")
		> 		strMsg.AppendLine("The Application will now exit.")
		> 		msg :=strMsg.Value
		> 		MsgBox, 8208, Critical Error, %msg%
		> 		ExitApp
		> 	}	
		> }
*/
cErrorBox(ErrorMsg, Title="", WindowTitle="", Owner=0){
	Global _CError_Result
	if (!ErrorBoxResult) {
		msg := MfString.Format(MfEnvironment.Instance.GetResourceString("NullReferenceException_MissingReference"), "ErrorBoxResult Class File")
		ex := new MfNullReferenceException(msg)
		ex.Source := A_ThisFunc
		ex.File := A_LineFile
		ex.Line := A_LineNumber
		throw ex
	}
	GuiID := 11
	If( Owner <> 0 ) {
		Gui %Owner%:+Disabled
		Gui %GuiID%:+Owner%owner%
	}
	strTitle := String.Empty
	if (MfString.IsNullOrEmpty(Title)) {
		strTitle := Script.Res.GetResourceStringBySection("Error_General_Title", "HANDLEERROR")
	} else {
		strTitle := Title
	}
	if (MfObject.IsObjInstance(ErrorMsg, MfException)) {
		msgError := ErrorMsg.ToString()
		if (MfString.IsNullOrEmpty(Title)) {
			strTitle := ErrorMsg.Message
		}
	} else {
		msgError := ErrorMsg
	}
	_BtnCopyToClip := Script.Res.GetResourceStringBySection("Btn_Copy_To_Clip", "HANDLEERROR")
	_BtnSaveAsFile := Script.Res.GetResourceStringBySection("Btn_Save_As_File", "HANDLEERROR")
	_BtnClose := Script.Res.GetResourceStringBySection("Btn_Close", "HANDLEERROR")
	Gui, %GuiID%:Add, Text, x22 y19 w540 h30 , %strTitle%
	Gui, %GuiID%:Add, Edit, x22 y69 w540 h240 -wrap -WantReturn ReadOnly VScroll HScroll, %msgError%
	Gui, %GuiID%:Add, Button, x22 y329 w110 h30 gCErrorButton, %_BtnCopyToClip%
	Gui, %GuiID%:Add, Button, x222 y329 w130 h30 gCErrorButton, %_BtnSaveAsFile%
	Gui, %GuiID%:Add, Button, x462 y329 w100 h30 gCErrorButton Default, %_BtnClose%
	Gui, %GuiID%:+Toolwindow +AlwaysOnTop
	Gui, %GuiID%:Show, w581 h379, % (WindowTitle) ? WindowTitle:strTitle
	;Gui, %GuiID%:Show,, % (WindowTitle) ? WindowTitle:Title
	
	Loop
	{
		If(_CError_Result) {
			Break
		}
	}
	If(Owner <> 0) {
		Gui %Owner%:-Disabled
	}
	Gui, %GuiID%:Submit, Hide

	if (_CError_Result = _BtnSaveAsFile){
		Result := new ErrorBoxResult(ErrorBoxResult.Instance.ToFile)
		; if(Result.Value = ErrorBoxResult.Instance.ToFile.Value) would result as true
	} else if (_CError_Result = _BtnCopyToClip) {
		Result := new ErrorBoxResult(ErrorBoxResult.Instance.ToClipBoard)
		; if(Result.Value = ErrorBoxResult.Instance.ToClipBoard.Value) would result as true
	} else {
		Result := new ErrorBoxResult(ErrorBoxResult.Instance.None)
		; if(Result.Value = ErrorBoxResult.Instance.None.Value) would result as true
	}
	_cError_Value := ""
	Gui %GuiID%:Destroy
  	Return Result
	
return
}


11GuiEscape:
11GuiClose:
  _CError_Result := Script.Res.GetResourceStringBySection("Btn_Close", "HANDLEERROR")
Return

CErrorButton:
  StringReplace _CError_Result, A_GuiControl, &,, All
Return
; 	End:cErrorBox ;}
;{ CMsgBoxErr Block
;{	CMsgBoxErr
/*!
	Function: CMsgBoxErr(title, text, buttons) or CMsgBox(title, text, buttons, icon) or CMsgBox(title, text, buttons, icon, owner)
		CMsgBoxErr() Generates a custom MesageBox and waits for the user input before continuing.
	Parameters:
		title - The title of the message box.  
		text - The text to display.  
		buttons - Pipe-separated list of buttons. Putting an asterisk in front of a button will make it the default.  
		icon - If blank, we will use an info icon. If a number, we will take this icon from Shell32.dll
			If a letter ("I", "E" or "Q") we will use some predefined icons from Shell32.dll (Info, Error or Question).  
		owner - If 0, this will be a standalone dialog. If you want this dialog to be owned by another GUI, place its number here.
*/
CMsgBoxErr( title, text, buttons, icon="", owner=0 ) {
	Global _CMsg_ResultErr

	GuiID := 12      ; If you change, also change the subroutines below

	StringSplit Button, buttons, |

	If( owner <> 0 ) {
		Gui %owner%:+Disabled
		Gui %GuiID%:+Owner%owner%
	}

	Gui %GuiID%:+Toolwindow +AlwaysOnTop

	MyIcon := ( icon = "I" ) or ( icon = "" ) ? 222 : icon = "Q" ? 24 : icon = "E" ? 110 : icon

	Gui %GuiID%:Add, Picture, Icon%MyIcon% , Shell32.dll
	Gui %GuiID%:Add, Text, x+12 yp w180 r8 section , %text%

	Loop %Button0%
	Gui %GuiID%:Add, Button, % ( A_Index=1 ? "x+12 ys " : "xp y+3 " ) . ( InStr( Button%A_Index%, "*" ) ? "Default " : " " ) . "w100 gCMsgButtonErr", % RegExReplace( Button%A_Index%, "\*" )

	Gui %GuiID%:Show,,%title%

	Loop
	If( _CMsg_ResultErr )
	  Break

	If( owner <> 0 )
	Gui %owner%:-Disabled

	Gui %GuiID%:Destroy
	Result := _CMsg_ResultErr
	_CMsg_ResultErr := ""
	Return Result
}

12GuiEscape:
12GuiClose:
  _CMsg_ResultErr := Script.Res.GetResourceStringBySection("Btn_Close", "HANDLEERROR")
Return

CMsgButtonErr:
  StringReplace _CMsg_ResultErr, A_GuiControl, &,, All
Return
;	End:CMsgBoxErr ;}
; End:CMsgBoxErr Block ;}

