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



Class BlackWhiteList extends MfObject
{
	/*
	  Blacklist Include written by Paul Moss July 4, 2013
	  This include parses the black list var to look for active windows
	*/
	m_dic := Null ; Listof semi-colon delimited values of blacklisted windows


	__New() {
		base.__New()
		this.m_dic := new MfDictionary()
	}
	
	/*
	Function: Add(WinTitle, WinText="" ,ExcludeTitle="",ExcludeText="")
		Add()
	Parameters:
		WinTitle - A window title or other criteria identifying the target window. See WinTitle.
		WinText -If present, this parameter must be a substring from a single text element of the target window 
				(as revealed by the included Window Spy utility). Hidden text elements are detected if DetectHiddenText is ON.
		ExcludeTitle - Windows whose titles include this value will not be considered. 
						Note: Due to backward compatibility, this parameter will be interpreted as a command if it exactly matches 
						the name of a command. To work around this, use the WinActive() function instead.
		ExcludeText - Windows whose text include this value will not be considered.
	Remarks:
		It the critera has alread been added to the list then it will not be added again.
	Returns:
		Return Integer value of the current count of the blacklist if successfully added to the list, otherwise 0
	*/
	Add(WinTitle, WinText="" ,ExcludeTitle="",ExcludeText="") {
		key := this._GetKey(WinTitle, WinText, ExcludeTitle, ExcludeText)

		retval := 0
		if (!this.m_dic.Contains(key)) {
			itm := new BlackWhiteList.Item(WinTitle, WinText, ExcludeTitle, ExcludeText)
			if (Script.dbg) {
				msg := MfString.Format("{0}: Window Added - Key:{1}: Value:{2}",A_ThisFunc, key, itm.ToString())
				Script.Debug(msg)
			}
			this.m_dic.Add(key, itm)
			retval := this.m_dic.Count
		} else {
			if (Script.dbg) {
				msg := MfString.Format("{0}: Already contains key '{1}'. Unable to add again",A_ThisFunc, key)
				Script.Debug(msg)
			}
		}
		return retval
	}
	
	/*
	Function: Remove(WinTitle, WinText="" ,ExcludeTitle="",ExcludeText="")
		Remove() Removes an item from the list
	Parameters:
		WinTitle - A window title or other criteria identifying the target window. See WinTitle.
		WinText -If present, this parameter must be a substring from a single text element of the target window 
				(as revealed by the included Window Spy utility). Hidden text elements are detected if DetectHiddenText is ON.
		ExcludeTitle - Windows whose titles include this value will not be considered. 
						Note: Due to backward compatibility, this parameter will be interpreted as a command if it exactly matches 
						the name of a command. To work around this, use the WinActive() function instead.
		ExcludeText - Windows whose text include this value will not be considered.
	Returns:
		Return Integer value of 1 is item was found and removed otherwise 0
	*/
	Remove(WinTitle, WinText="" ,ExcludeTitle="",ExcludeText="") {
		key := this._GetKey(WinTitle, WinText, ExcludeTitle, ExcludeText)
		retval := 0
		if(this.m_dic.Contains(key)) {
			this.m_dic.Remove(key)
			retval := 1
		}
		return retval
	}

	/*
	Function:_GetKey()
		_GetKey() Creates a key from the parmaaters and returns the key
	Returns:
		Returns a string representing a key
	*/
	_GetKey(WinTitle, WinText="" ,ExcludeTitle="",ExcludeText="")
	{
		key := WinTitle . ":" . WinText . ":" . ExcludeTitle . ":" . ExcludeText
		objStr := new MfString(key)
		return objStr.GetHashCode()
	}

	/*
	Function: GetWindowActive()
		GetWindowActive() Gets the HWND if a window in the list is active otherwise returns zero (0x0)
	Returns:
		Return The HWND of active window if it is in list otherwise returs zero (0x0)
	*/
	GetWindowActive() {
		

		vlist := this.m_dic
		vHWND := 0x0
		if (Script.dbg > 2) {
			Script.Debug(MfString.Format("{0}: There currently {1} windows in the list", A_ThisFunc, vlist.Count))
		}
		For k, v in vlist
		{
			if (Script.dbg > 2) {
				msg := MfString.Format("{0}: Searching for - Key:{1}: Value:{2}",A_ThisFunc, k, v.ToString())
				Script.Debug(msg)
			}
			;text := k . "=" . v
			WinTitle := v.WinTitle
			WinText := v.WinText
			ExcludeTitle := v.ExcludeTitle
			ExcludeText := v.ExcludeText
			
			vHWND := WinActive(WinTitle,WinText,ExcludeTitle,ExcludeText)
			if (vHWND) {
				if (Script.dbg > 2) {
					Script.Debug(MfString.Format("{0}:Found Active Window for {1}", A_ThisFunc, v.ToString()))
				}
				break ; no need to continue if a matching window is already found
			}
		}
		if (Script.dbg > 2) {
			if (vHWND = 0) {
				Script.Debug(MfString.Format("{0}:Active Window Not Found", A_ThisFunc))				
			}
		}
		if(this.m_GlobalProfile = true)
		{
			; if we are using a globlal profile then all matches are now to be ignored rather then included
			; Toggle the result to act as black list rather then white list. Now all that would have been
			; included are exlcuded and all that would have been exclude are now included.
			if(vHWND = 0x0)
			{
				vHWND = 0x270F
			} else {
				vHWND = 0x0
			}
		}
		if(Script.dbg > 1)
		{
			Script.Debug(MfString.Format("{0}: The return Value for {0} is:{1}", A_ThisFunc, vHWND))
		}
		return vHWND
	}
	
	__Delete()
	{
		this.m_dic := Null
		
	}

	;{ GlobalProfile
	m_GlobalProfile	:= False
	GlobalProfile[]
	{
		get {
			return this.m_GlobalProfile
		}
		set {
			this.m_GlobalProfile := value
		}
	}
	; End:GlobalProfile ;}

	Class Item extends MfObject
	{
		__New(WinTitle="", WinText="" ,ExcludeTitle="",ExcludeText="") {
			base.__New()
			this.m_WinTitle := WinTitle
			this.m_WinText := WinText
			this.m_ExcludeTitle := ExcludeTitle
			this.m_ExcludeText := ExcludeText
		}

	;{ WinTitle
		m_WinTitle	:= Null
		WinTitle[]
		{
			get {
				return this.m_WinTitle
			}
			set {
				this.m_WinTitle := value
			}
		}
	; End:WinTitle ;}
	;{ WinText
		m_WinText	:= Null
		WinText[]
		{
			get {
				return this.m_WinText
			}
			set {
				this.m_WinText := value
			}
		}
	; End:WinText ;}
	;{ ExcludeTitle
		m_ExcludeTitle	:= Null
		ExcludeTitle[]
		{
			get {
				return this.m_ExcludeTitle
			}
			set {
				this.m_ExcludeTitle := value
			}
		}
	; End:ExcludeTitle ;}
	;{ ExcludeText
		m_ExcludeText	:= Null
		ExcludeText[]
		{
			get {
				return this.m_ExcludeText
			}
			set {
				this.m_ExcludeText := value
			}
		}
	; End:ExcludeText ;}
	

		ToString()
		{
			str := this.m_WinTitle . ":" . this.m_WinText . ":" . this.m_ExcludeTitle . ":" this.m_ExcludeText
			return str
		}
	}
	
}