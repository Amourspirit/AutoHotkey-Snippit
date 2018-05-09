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



;{ cInputBox Displays custom input box
/* 
 * ======================================================================================================================================================
	cInputBox - Custom input box that can be use to capture input or passwords
	Params:
		title = The title to be displayed on the input box
		text = The text to be displayed above the input box
		InputValue = Optional - The inital value of the Inputbox
		owner = Optional - If 0, this will be a standalone dialog. If you want this dialog to be owned by another GUI, place its number here.
		isPassword = Optional - If non-zero or true then the input box will use password masking
	Usage:
		InputResult := cInputBox("The title", "The Text", "secret",,1)
		if (InputResult) {
			MsgBox, 64, Result Found, The result from the custom input box is: %InputResult%
		} else {
			MsgBox, 16, Result Error, The was no result returned from the custom input box
		}
	Other Notes:
		The GuiID should be sufficent for most uses. If however it conflicts then you will need to change it in three places
			GuiID := (New ID number) - found in the second line of the cInpuBox functon
			(New ID number)GuiEscape: - Found just below cInputBox function
			(New ID number)GuiClose: - Found just below cInputBox function
 * ======================================================================================================================================================
 */
cInputBox(title, text, inputValue = "", owner=0,isPassword=0) {
	Global _CInput_Result, _cInput_Value
	GuiID := 8      ; If you change, also change the subroutines below for #GuiEscape & #GuiClose
	If( owner <> 0 )
	{
		Gui %owner%:+Disabled
		Gui %GuiID%:+Owner%owner%
	}
  
	Gui, %GuiID%:Add, Text, x12 y10 w320 h20 , %text%
	Gui, %GuiID%:Add, Edit, % "x12 y40 w320 h20 R1 -VScroll v_cInput_Value" . ((isPassword <> 0) ? " Password":""), %inputValue%
	Gui, %GuiID%:Add, Button, x232 y70 w100 h30 gCInputButton, % "Cancel"
	Gui, %GuiID%:Add, Button, x122 y70 w100 h30 gCInputButton Default, % "OK"
	Gui, %GuiID%:+Toolwindow +AlwaysOnTop
	Gui %GuiID%:Show,,%title%
 
	Loop
		If( _CInput_Result )
			Break

	If( owner <> 0 )
		Gui %owner%:-Disabled
	Gui, %GuiID%:Submit, Hide

	if (_CInput_Result = "OK")
	{
		Result := _cInput_Value
	} else {
		Result := ""
	}
	_cInput_Value := ""
	_CInput_Result := ""
	Gui %GuiID%:Destroy
  	Return Result
}

8GuiEscape:
8GuiClose:
  _CInput_Result := "Close"
Return

CInputButton:
  StringReplace _CInput_Result, A_GuiControl, &,, All
Return