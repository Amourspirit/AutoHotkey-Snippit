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
	Class: ErrorBoxResult
		Specifies whether applicable MfString.Split method overloads include or omit
		empty substrings from the return value.  
		ErrorBoxResult is a Sealed Class and cannot be inherited.
	Inherits: Enum
*/
class ErrorBoxResult extends MfEnum
{
	static m_Instance := Null
;{ Constructor: ()
/*
	Constructor: ()
		Constructor for class ErrorBoxResult Class
	Throws:
		Throws MfNotSupportedException if this Sealed class is inherited.
*/
	__New(value) {
		if (this.base.__Class != "ErrorBoxResult") {
			throw new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Sealed_Class","ErrorBoxResult"))
		}
		base.__New(value)
	}
; End:Constructor: () ;}

;{ Method
;{ 	AddEnums()
/*
	Method: AddEnums()
		AddEnums() Processes adding of new Enum values to derived class.  
		Overrides MfEnum.AddEnums
	Remarks:
		This method is call by base class and does not need to be call manually.
*/
	AddEnums() {
		this.AddEnumValue("None", 0)
		this.AddEnumValue("ToClipBoard", 1)
		this.AddEnumValue("ToFile",2)
	}
; 	End:AddEnums() ;}
;{	DestroyInstance()
/*
	Method: DestroyInstance()
		DestroyInstance() Destroys the singleton instance of ErrorBoxResult
		Overrides MfEnum.DestroyInstance
*/
	DestroyInstance() {
		ErrorBoxResult.m_Instance := Null
	}
; End:DestroyInstance() ;}
;{ 	GetInstance()
/*
	Method: GetInstance()
		GetInstance() Gets the instance for the ErrorBoxResult class.  
		Overrides MfEnum.GetInstance
	Remarks:
		ErrorBoxResult.DestroyInstance can be called to destroy instance.
	Returns:
		Returns Singleton instance for ErrorBoxResult class.
*/
	GetInstance() {
		if (ErrorBoxResult.m_Instance = Null) {
			ErrorBoxResult.m_Instance := new ErrorBoxResult(0)
		}
		return ErrorBoxResult.m_Instance
	}
; End:GetInstance() ;}
; End:Method ;}
;{ Properties

; End:Properties ;}	
}
/*!
	End of class
*/