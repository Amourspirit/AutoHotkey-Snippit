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



/*!
	Class: SnippyResourceManager
		Class for getting resources for errors and other string
	Inherits: MfObject
	Extra:
		The SnippyResourceManager class is not intended to be use by developer.  
		Sealed Class  
		This class uses DllPack_Read by SKAN
		More info can be found at [http://www.autohotkey.com/board/topic/57631-crazy-scripting-resource-only-dll-for-dummies-36l-v07/](http://www.autohotkey.com/board/topic/57631-crazy-scripting-resource-only-dll-for-dummies-36l-v07/)
*/
class SnippyResourceManager extends MfObject
{
	m_CoreRes := Null
;{ 	Constructor
	/*!
		Constructor() or Constructor(lang)
			Constructor for class
		Parameters:
			lang - the language to load the resoure file of. Defaults to en_US
		Throws:
			Throws MfNotSupportedException is class is extended
	*/
	__New(lang = "en-US") {
		base.__New()
		; Throws MfNotSupportedException if SnippyResourceManager Sealed class is extended
		if (this.__Class != "SnippyResourceManager") {
			throw new MfNotSupportedException("SnippyResourceManager is seal class!")
		}	
		
		this.SetResDir(lang)
		this.m_isInherited := this.__Class != "SnippyResourceManager"
		
	}
; 	End:Constructor ;}
	/*!
		Method: SetResDir(lang)
			SetResDir() Attempts to load resources file for the given language
		Parameters:
			lang - The language to load the resourece file for
		Throws:
			Throws [MfSystemException](MfSystemException.html) if unable to locate a valid resourec file
	*/
	SetResDir(lang) {
		if (this.CoreRes = Null) {
			sFile := MfString.Format("Resource_Core_{0}.dll", lang)
			
			this.CoreRes := MfString.Format("{0}\Resource\Resource_Core_{1}.dll", A_ScriptDir, lang)
			if (FileExist(this.CoreRes)) {
				return
			}
			this.CoreRes := MfString.Format("{0}\Resources\Resource_Core_{1}.dll", A_ScriptDir, lang)
			if (FileExist(this.CoreRes)) {
				return
			}
			this.CoreRes := MfString.Format("{0}\Resource_Core_{1}.dll", A_ScriptDir, lang)
			if (FileExist(this.CoreRes)) {
				return
			}
			
			this.CoreRes := Null
			msg := "Unable to locate core Resource File.`nTry placing the core resource file (Resource_Core_{0}.dll) in a subfolder"
			msg .= " named Resource for the current running script.`nExpected Resource\Resource_Core_{0}.dll"
		
			ex := new MfSystemException(MfString.Format(msg,lang))
			ex.Source := A_ThisFunc
			throw ex
		}
	}
;{ 	GetResourceString
	/*!
		Method: GetResourceString(key, Section)
			GetResourceString(key) Get a resoururce string from the resource file CORE section
			GetResourceString(key, Section) Get a resource string from the resource file at the specified section.
		Parameters:
			key - the key of th ini file to read from in the resource file.
			Section - the section of the ini file to read from in the resource file.
		Remarks:
			Not indended for use by developers but rather by the Mini-Framework
		Returns:
			Returns a string var containing the resoure string or "" if key is not found.
	*/
	GetResourceString(key, Section="CORE") {
		result := ""
		_coreRes := this.CoreRes
		IniRead, result, %_coreRes%, %Section%, %key%, ""
		return result
	}
; 	End:GetResourceString ;}
;{ 	IsValidLanguageResource
	/*!
		Method: IsValidLanguageResource(lang)
			IsValidLanguageResource() Test to see if a resource file can be found for a given language
			at predefined locations.
		Parameters:
			lang - The language to check for such as "en-US"
		Remarks:
			some remaarks here
		Returns:
			Returns **true** if the resource file if found otherwise **false**.
		Extra:
			Valid Resource paths are in the folowing locations.  
			A_ScriptDir\Resource\  
			A_ScriptDir\Resources\  
			A_ScriptDir\  
			Resource file are named in the format of `Resource_Core_en-US.dll` where `en-US` is Substituted for the language
			being checked for by the *lang* parameter
	*/
	IsValidLanguageResource(lang) {
		
			res := MfString.Format("{0}\Resource\Resource_Core_{1}.dll", A_ScriptDir, lang)
			if (FileExist(Res)) {
				return true
			}
			
			res := MfString.Format("{0}\Resources\Resource_Core_{1}.dll", A_ScriptDir, lang)
			if (FileExist(Res)) {
				return true
			}
			
			res :=  MfString.Format("{0}\Resource_Core_{1}.dll", A_ScriptDir, lang)
			if (FileExist(Res)) {
				return true
			}
			return false
	}
; 	End:IsValidLanguageResource ;}

}
/*!
	End of class
*/