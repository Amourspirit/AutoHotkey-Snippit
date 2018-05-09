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



#Include <Resource_Only_Dll>
ResFolder := A_ScriptDir . "\Resource"
try {
	SetWorkingDir, %ResFolder%
	strF := ResFolder . "\Resources"
	DllPack_Files(strF, "Resource_Core_en-US.dll")
} catch e {
	MsgBox, 8240, Error, % "An error has occured!`r`n" . e.Message
}
MsgBox All done!