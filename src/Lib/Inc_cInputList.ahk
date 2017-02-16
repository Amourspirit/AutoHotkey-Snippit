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



cInputList(dl, owner=0) {
	Global _CInputList_Result, _cInputList_Value
	if (MfNull.IsNull(dl))
	{
		ex := new MfNullReferenceException(MfEnvironment.Instance.GetResourceString("NullReferenceException_Object_Param", A_ThisFunc))
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
	; dl is instance of DiaglogList
	if(MfObject.IsObjInstance(dl, "DiaglogList") == false && MfObject.IsObjInstance(dl, "inputFixedList") = false)
	{
		ex := new MfArgumentException(MfEnvironment.Instance.GetResourceString("Argument_IncorrectObjType"
				, "dl", "DiaglogList or inputFixedList"),"dl")
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}

	GuiID := 9      ; If you change, also change the subroutines below for #GuiEscape & #GuiClose
	If( owner <> 0 )
	{
		Gui %owner%:+Disabled
		Gui %GuiID%:+Owner%owner%
	}
	strText := dl.dialogtext
	strTitle := dl.dialogtitle

	strList := ""
	for i, li in dl.listValues
	{
		if (li.default = true)
		{
			strList .= li.Value . "||" ; Double || makes the this item be selected
		} else {
			strList .= li.Value . "|"
		}
	}

	Gui, %GuiID%:Add, Text, x12 y19 w400 h26 , %strText%
	Gui, %GuiID%:Add, DropDownList, x12 y49 w400 h260 v_cInputList_Value, %strList%
	Gui, %GuiID%:Add, Button, x312 y79 w100 h30 gCInputListButton, % "Cancel"
	Gui, %GuiID%:Add, Button, x202 y79 w100 h30 gCInputListButton Default, % "OK"

	Gui, %GuiID%:+Toolwindow +AlwaysOnTop
	Gui %GuiID%:Show,,%strTitle%
	Loop
		If( _CInputList_Result )
			Break

	If( owner <> 0 )
		Gui %owner%:-Disabled
	Gui, %GuiID%:Submit, Hide

	if (_CInputList_Result = "OK")
	{
		Result := _cInputList_Value
	} else {
		Result := ""
	}
	_cInputList_Value := ""
	_CInputList_Result := ""
	Gui %GuiID%:Destroy
  	Return Result
}
9GuiEscape:
9GuiClose:
  _CInputList_Result := "Close"
Return

CInputListButton:
  StringReplace _CInputList_Result, A_GuiControl, &,, All
Return












cInputListLong(strText, strTitle, strList, owner=0) {
	Global _CInputList_Result, _cInputList_Value
	if(MfString.IsNullOrEmpty(strText))
	{
		ex := new MfArgumentNullException("strText")
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
	if(MfString.IsNullOrEmpty(strTitle))
	{
		ex := new MfArgumentNullException("strTitle")
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
	if(MfString.IsNullOrEmpty(strList))
	{
		ex := new MfArgumentNullException("strList")
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}
	
	GuiID := 10      ; If you change, also change the subroutines below for #GuiEscape & #GuiClose
	If( owner <> 0 )
	{
		Gui %owner%:+Disabled
		Gui %GuiID%:+Owner%owner%
	}

	Gui, %GuiID%:Add, Text, x12 y19 w400 h26 , %strText%
	Gui, %GuiID%:Add, DropDownList, x12 y49 w400 h260 v_cInputList_Value, %strList%
	Gui, %GuiID%:Add, Button, x312 y79 w100 h30 gCInputListButton, % "Cancel"
	Gui, %GuiID%:Add, Button, x202 y79 w100 h30 gCInputListButton Default, % "OK"

	Gui, %GuiID%:+Toolwindow +AlwaysOnTop
	Gui %GuiID%:Show,,%strTitle%
	Loop
		If( _CInputList_Result )
			Break

	If( owner <> 0 )
		Gui %owner%:-Disabled
	Gui, %GuiID%:Submit, Hide

	if (_CInputList_Result = "OK")
	{
		Result := _cInputList_Value
	} else {
		Result := ""
	}
	_cInputList_Value := ""
	_CInputList_Result := ""
	Gui %GuiID%:Destroy
  	Return Result
}
10GuiEscape:
10GuiClose:
  _CInputList_Result := "Close"
Return
