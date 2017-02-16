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


Class Settings extends MfObject
{
	m_Ini := Null

	__New() {
		base.__New()
		this.m_Ini := MfString.Format("{0}\{1}\{2}", A_AppData, Script.DataFolder, "settings.ini")
		this.Init()
	}

#IncludeAgain, %A_ScriptDir%\Lib\Inc_Partial_Class_Debug.ahk

	Init()
	{
		if (!FileExist(this.m_Ini)) {
			this.m_AppHotList := MfString.Format("{0}\{1}\{2}", A_ScriptDir, "bin", "HotList.exe")
			this.m_AppSwap := MfString.Format("{0}\{1}\{2}", A_ScriptDir, "bin", "ProfileSwap.exe")
			Mfunc.IniWrite("AutoHotkey.xml", this.m_Ini, "PROFILE", "current")
			Mfunc.IniWrite(this.m_AppHotList, this.m_Ini, "APPS", "hotlist")
			Mfunc.IniWrite(this.m_AppSwap, this.m_Ini, "APPS", "swap")
		}
		this.m_ProfileCurrent := Mfunc.IniRead(this.m_ini, "PROFILE", "current")
		this.m_AppHotList := Mfunc.IniRead(this.m_ini, "APPS", "hotlist")
		this.m_AppSwap := Mfunc.IniRead(this.m_ini, "APPS", "swap")
	}

	Save() 
	{
		Mfunc.IniWrite(this.m_ProfileCurrent, this.m_Ini, "PROFILE", "current")
		Mfunc.IniWrite(this.m_AppHotList, this.m_Ini, "APPS", "hotlist")
		Mfunc.IniWrite(this.m_AppSwap, this.m_Ini, "APPS", "swap")
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
;{ 		ProfileCurrent
	m_ProfileCurrent := Null
	; the Version of the settings file
	ProfileCurrent[]
	{
		get {
			return this.m_ProfileCurrent
		}
		set {
			this.m_ProfileCurrent := value
			return this.m_ProfileCurrent
		}
	}
; 		End:ProfileCurrent ;}
;{ 	AppHotList

	m_AppHotList := Null
	AppHotList[]
	{
		get {
			return this.m_AppHotList
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 	End:AppHotList ;}
;{ 	AppSwap
	m_AppSwap := Null
	AppSwap[]
	{
		get {
			return this.m_AppSwap
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 	End:AppSwap ;}
}