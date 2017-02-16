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


; AppSetting are the settings for the application state and such
Class AppSettings extends MfObject
{
	m_Ini := Null

	__New() {
		base.__New()
		this.m_Ini := MfString.Format("{0}\{1}\{2}", A_AppData, Script.DataFolder, "app.ini")
		this.Init()
	}

#IncludeAgain, %A_ScriptDir%\Lib\Inc_Partial_Class_Debug.ahk

	Init()
	{
		this.m_ScriptPath := A_ScriptFullPath
		this.m_ScriptLoaded := 1
		if (!FileExist(this.m_Ini)) {
			Mfunc.IniWrite(this.m_ScriptPath, this.m_Ini, "SCRIPT", "path")
			Mfunc.IniWrite(A_ScriptName, this.m_Ini, "SCRIPT", "MainScriptFile")
			Mfunc.IniWrite(this.m_ScriptLoaded, this.m_Ini, "SCRIPT", "load_state")
			Mfunc.IniWrite(Script.Version, this.m_Ini, "SCRIPT", "version")
			Mfunc.IniWrite("0", this.m_Ini, "WRITER", "exitcode")
		}
	}


	Save() 
	{
		Mfunc.IniWrite(this.m_ScriptPath, this.m_Ini, "SCRIPT", "path")
		Mfunc.IniWrite(A_ScriptName, this.m_Ini, "SCRIPT", "MainScriptFile")
		Mfunc.IniWrite(this.m_ScriptLoaded, this.m_Ini, "SCRIPT", "load_state")
		Mfunc.IniWrite(Script.Version, this.m_Ini, "SCRIPT", "version")
		; set the current app reload state to zero
		Mfunc.IniWrite("0", this.m_Ini, "WRITER", "exitcode")
	}
;{ 	SectionExist
	/*
		Method:SectionExist()
			SectionExist Gets if a section exist in the ini file
		Parameters:
			SectionName - the name of the section to check for.
		Returns:
			True if section Exist oherewise false
	*/
	SectionExist(SectionName) {
		section := Mfunc.IniRead(this.m_Ini, SectionName)
		if (section) {
			return true
		}
		return false
	}
; 	End:SectionExist ;}

;{ 	ScriptPath
	m_ScriptPath		:= Null
	ScriptPath[]
	{
		get {
			return this.m_ScriptPath
		}
		set {
			this.m_ScriptPath := value
			return this.m_ScriptPath
		}
	}
; 	End:ScriptPath ;}
	m_ScriptLoaded		:= 1
	ScriptLoaded[]
	{
		get {
			return this.m_ScriptLoaded
		}
		set {
			this.m_ScriptLoaded := value
			return this.m_ScriptLoaded
		}
	}
}