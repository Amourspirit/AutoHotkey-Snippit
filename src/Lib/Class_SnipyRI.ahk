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
	Class: SnipyRI
		SnipyRI is a Sealed Class and cannot be inherited.
	Inherits: MfSingletonBase
*/
class SnipyRI extends MfResourceSingletonBase
{
	static _instance := Null ; Static var to contain the singleton instance
	m_Rm := Null
;{ Constructor
    /*!
		Constructor()
			Constructor new instance of [MfEnvironment](MfEnvironment.html) class
		Throws:
			Throws MfNotSupportedException is class is extended
	*/
	 __New() {
        ; Throws MfNotSupportedException if MfEnvironment Sealed class is extended
        if (this.__Class != "SnipyRI") {
            throw new MfNotSupportedException("Error! Sealed Class!")
        }
        base.__New()
        this.m_isInherited := this.__Class != "SnipyRI"
		if ((LanguagePack) && (SnippyResourceManager.IsValidLanguageResource(LanguagePack))) {
			this.m_Rm := new SnippyResourceManager(LanguagePack)
		} else {
			this.m_Rm := new SnippyResourceManager()
		}
    }
; End:Constructor ;}
;{ Reset
    /*!
        Method: Reset()
            Reset() resets the current Enviroment instance so the the next call it is loaded again
        Remarks:
            Useful if loading a new resource file of another language.
    */
    Reset() {
        SnipyRI._instance := Null
    }
; End:Reset ;}
;{ GetResourceString
    /*!
        Method: GetResourceString(Key, args)
            GetResourceString() Gets a resource string from the current resource file.
        Parameters:
            key - Param info here
            args - arguments that can be passed in to format a string.
        Example:
            > ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_AbstractClass", "MyAbstractClass"))
            > ex.Source := A_ThisFunc
            > ex.File := A_LineFile
            > ex.Line := A_LineNumber
            > throw ex
    */
	GetResourceString(key , args*) {
        if (!args.MaxIndex()) {
            return this.m_Rm.GetResourceString(key)
        }
		strRes := this.m_Rm.GetResourceString(key)
        return MfString.Format(strRes, args*)
        
	}
; End:GetResourceString ;}
;{ GetResourceStringBySection
    /*!
        Method: GetResourceStringBySection(Key, section, args)
            GetResourceStringBySection() Gets a resource string from the current resource file.
        Parameters:
            key - Param info here
			section - Section of resource ini to get string value from.
            args - arguments that can be passed in to format a string.
        Example:
            > ex := new MfNotSupportedException(MfResourceSingletonBase.Instance.GetResourceString("NotSupportedException_AbstractClass", "MyAbstractClass"))
            > ex.Source := A_ThisFunc
            > ex.File := A_LineFile
            > ex.Line := A_LineNumber
            > throw ex
    */
	GetResourceStringBySection(key, section, args*) {
      if (!args.MaxIndex()) {
            return this.m_Rm.GetResourceString(key, section)
        }
		strRes := this.m_Rm.GetResourceString(key, section)
        return MfString.Format(strRes, args*)     
	}
; End:GetResourceString ;}
;{ GetInstance
	/*!
		Method: GetInstance()
			GetInstance() Gets the instance of the Singleton for MfEnvironment
            Overrides [MfSingletonBase.GetInstance](MfSingletonBase.GetInstance.html) method.
		Returns:
			Returns Singleton instance for the MfEnvironment class.
	*/
    GetInstance() { ; Overrides base
        if (SnipyRI._instance = Null) {
            SnipyRI._instance := new SnipyRI()
        }
        return SnipyRI._instance
    }
; End:GetInstance ;}

;{ Properties

; End:Properties ;}
}
/*!
	End of class
