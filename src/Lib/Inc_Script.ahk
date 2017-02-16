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


#Include <scriptobj>

DataFolder := "AutoHotkey Snippit"
global Script := { base : scriptobj
	  ,Name : "AutoHotkey Snippit"
	  ,Version : "0.7.3.0"
	  ,author : "Paul Moss"
	  ,email : "info@bigbytetech.ca"
	  ,homepage : "http://www.bigbytetech.ca"
	  ,crtdate : "Dec 15, 2014"
	  ,moddate : "Feb 15, 2017"
	  ,Year : "2017"
	  ,conf : Null
	  ,DataFolder : DataFolder
	  ,LaunchedBy : "self"
	  ,ThisScript :""}
Script.getparams()
DataFolder := ""