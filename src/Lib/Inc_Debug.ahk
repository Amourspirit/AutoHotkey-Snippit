﻿;{ License
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



;{ Debug
/*
Function: Debug(msg, params*)
	Debug() Writes debug to output or file
Parameters:
	msg - String value The message for the debug
	params - one ore more parameters used to format the message
Remarks:
	For debugging purposes. Debug Messages that are at any debug level are debuged.
Returns:
	No Return
Extra:
	Expects for find Script object in lib Inc_Script.ahk
	The Script object does all the real work.
	The Script can be started using various command line
	options to save the debug info to a file.
	See DebugLevel for debugging using debug verbose levels.
*/
Debug(msg, params*) {
    if (Script.dbg) {
        _msg := MfString.Format(msg, params*)
        Script.Debug(_msg)
    }
}
; End:Debug ;}

;{ DebugLevel(msg, level, params*)
/*
Function: DebugLevel(msg, level, params*)
	DebugLevel() Writes debug to output or file if verbose leves is met
Parameters:
	msg - String value The message for the debug
	Level - number value of the verbose level to write the debug message
	params - one ore more parameters used to format the message
Remarks:
	For debugging purposes
	If Script.dbg value is less then the level parameter then the debug message
	is ignored.
Returns:
	No Return
Extra:
	Expects for find Script object in lib Inc_Script.ahk
	The Script object does all the real work.
	The Script can be started using various command line
	options to save the debug info to a file
*/
DebugLevel(msg, Level, params*) {
	if ((Script.dbg) && (Script.dbg >= Level)) {
		_msg := MfString.Format(msg, params*)
		Script.Debug(_msg)
	}
}

	
; End:DebugError(e, level, Method) ;}

;{ DebugLevel(msg, Level, params*)
/*
Function: DebugLevel(e, Level, Method)
	DebugLevel() Writes debug for error to output or file if verbose leves is met
Parameters:
	e - An Error Object or instance of MfException that contains the error
	Level - Optional number value of the verbose level to write the debug message. Default is 1
	Method - Optional Method that the errror occured in
	LineNumber - Optional Line number the error occured on
Remarks:
	For debugging purposes
	If Script.dbg value is less then the level parameter then the debug message
	is ignored.
Returns:
*/
DebugError(e, Level=1, Method="", LineNumber=0)
{
	if ((Script.dbg) && (Script.dbg >= Level))
	{
		strErr := Null
		if (MfObject.IsObjInstance(e, MfException)) {
			strErr := e.ToString()
		} else if (IsObject(e)) {
			strErr := e.Message
		} 
		msg := ""
		if(LineNumber > 0) {
			msg .= "Error on Line:" . LineNumber . " - "
		}
		if(MfString.IsNullOrEmpty(Method)) {
			msg .= "An Error has Occured: " . strErr
		} else {
			msg .= MfString.GetValue(Method) . ": An Error has Occured: " . strErr
		}
		Script.Debug(msg)
		strErr := Null
	}
}

;{ DebugElapsed(FunctionName, DebugStartTime)
/*
	Function: DebugElapsed(FunctionName, DebugStartTime, IsFunction := true, Level := 3)
		DebugElapsed() Sends output to Debug of function name and time elapsed
	Parameters:
		FunctionName - The name of the function that is calling
		DebugStartTime - The Start time as a Tickcount
		IsFunction - Default true. If FunctionName is a function then the debug formatting is a little different
		Level - Default 3. Set the verbose level needed to output the debug message. Can be 1, 2 or 3. 1 is the least
		verbose and 3 is the most verbose. Level 0 will not be outputed at all.
*/
DebugElapsed(FunctionName, DebugStartTime, IsFunction := true, Level := 2) {
	global Script
	;global Script
	if ((!Script.dbg) || (Script.dbg < Level)) {
		return
	}
	try {
		DebugEndtime := A_TickCount
		DebugElapsed :=  _DebugSecondsPassed(DebugStartTime, DebugEndtime)
		DotIndex := -1
		try {
			DotIndex := Mfunc.StringGetPos(DebugElapsed,".")
		} catch e {
			Debug("[{0}] Error, Unable to get Elapsed time:", A_ThisFunc)
			if (IsFunction) {
				Debug("{0}", FunctionName)
			} else {
				Debug("[{0}]", FunctionName)
			}
			return
		}
				
		CutIndex := dotIndex + 3
		strDE := new MfString(DebugElapsed)
		strElapsed := strDE.CutIfLong(CutIndex,"")
		DebugTimeMsg := MfString.Format("Executed in {0} sec", strElapsed)
		if (IsFunction) {
			Debug("{0} {1}", FunctionName, DebugTimeMsg)
		} else {
			Debug("[{0}] {1}", FunctionName, DebugTimeMsg)
		}
	} catch e {
		msg := "Error gathering Debug Elapsed Time for " . A_ThisFunc . ". Failure for Function:" . FunctionName
		msg .= "`n" . e.Message
		this.Debug(msg)
	} finally {
		strDE := ""
		
	}
	
}
; End:DebugElapsed(FunctionName, DebugStartTime) ;}
;{ 	SecondsPassed(StartTime [, Endtime])
/*
	Method: _DebugSecondsPassed(StartTime [, Endtime])
		_DebugSecondsPassed() Gets the time passed From *StartTime* to *Endtime*
	Parameters:
		StartTime - Tickcount value
		Endtime - Tickcount value. Optional
	Remarks:
		If *Endtime* is omited **SecondsPassed** returns calculated time from *StartTime*
		to call of function.  
		*Static* method can be use as AhkObject.SecondsPassed(StartTime [, Endtime])
		or this.SecondsPassed(StartTime [, Endtime]) in derived classes
	Returns:
		Returns time passed in seconds
	Extra:
		**_DebugSecondsPassed** can be usefull for *debugging* purposes
	Throws:
		Does not throw any errors
*/
_DebugSecondsPassed(StartTime, Endtime := "") {
	if ((!StartTime) || (!_DebugIsNumeric(StartTime))) {
	return 0
	}
	tcount := A_TickCount
	if(_DebugIsNumeric(Endtime)) {
	 tcount := Endtime
	}
	ElapsedTime := ((tcount - StartTime) / 1000)
	return ElapsedTime
}

_DebugIsNumeric(x)
{
	If x is number 
	  Return 1 
	Return 0 
}
; End:DebugError(msg, level, params*) ;}