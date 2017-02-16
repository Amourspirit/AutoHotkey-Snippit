﻿;{ License
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


/*
	Class: XmlHelper
		XmlHelper class contains various methods for working with XML.  
		XmlHelper class is a stacic class.
	Extra:
		Requires Mini-Framework
*/
Class XmlHelper {
	/*
		Constructor: ()
			Constructor for class [XmlHelper](XmlHelper.html) will throw an error.
			This is a static class an will not allow instances.
		Throws:
			Throws `MfNotSupportedException` if Constructor is called.
	*/
	__New() {
		ex := new MfNotSupportedException(MfString.Format(MfEnvironment.Instance.GetResourceString("NotSupportedException_Static_Class"), "XmlHelper"))
		ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
		throw ex
	}

	; runs xpath on the method and returns XML Decoded result using xmlHleper.Decode
	xDecode(ByRef doc, step, set = "")
	{
		result := XmlHelper.xpath(doc, step, set)
		return XmlHelper.Decode(result)
	}
/*
	Function: Decode(str)
		Decode() Decodes Xml
	Parameters:
		str - The xml String to Decode, can be var of string or MfString object
	Returns:
		Returns string var containing the decode xml
	Remarks:
		If str value is null or Empty the MfString.Empty is returned
	Throws:
		Throws MfException on any caught errors
	Example:
		> ReplacementsCount := XmlHelper.xpath(xml, "/replacements/replacement/count()")
		> Loop,%ReplacementsCount%
		> {
		> 	ri := new ReplacementItem()
		> 	
		> 	xmlDialogType := MfString.Format("/replacements/replacement[{0}]/dialogtype/text()",A_Index)
		> 	sDialogType := new MfString(XmlHelper.xpath(xml, xmlDialogType))
		> 	sDialogType.Trim()
		> 	ri.DialogType := sDialogType.Value
		> 	
		> 	xmlDialogText := MfString.Format("/replacements/replacement[{0}]/dialogtext/text()",A_Index)
		> 	sDialogText := new MfString(XmlHelper.xpath(xml, xmlDialogText))
		> 	sDialogText.Trim()
		> 	ri.DialogText := XmlHelper.Decode(sDialogText.Value)
		> 	
		> 	xmlDialogTitle := MfString.Format("/replacements/replacement[{0}]/dialogtitle/text()",A_Index)
		> 	sDialogTitle := new MfString(XmlHelper.xpath(xml, xmlDialogTitle))
		> 	sDialogTitle.Trim()
		> 	ri.DialogTitle := XmlHelper.Decode(sDialogTitle.Value)
		> 	
		> 	xmlDialogIv := MfString.Format("/replacements/replacement[{0}]/dialoginitialvalue/text()",A_Index)
		> 	sDialogIv := new MfString(XmlHelper.xpath(xml, xmlDialogIv))
		> 	sDialogIv.Trim()
		> 	ri.DialogInitialValue := XmlHelper.Decode(sDialogIv.Value)
		> 	
		> 	this.m_Replacements.Add(ri)
		> }
*/
	Decode(str)
	{
		if(MfString.IsNullOrEmpty(str)) {
			return MfString.Empty
		}
		retval := MfString.GetValue(str)
		try {
				retval := Mfunc.StringReplace(retval, "&amp;", "&", 1)
				retval := Mfunc.StringReplace(retval, "&quot;", """", 1)
				retval := Mfunc.StringReplace(retval, "&apos;", "'", 1)
				retval := Mfunc.StringReplace(retval, "&#32;", " ", 1)
				retval := Mfunc.StringReplace(retval, "&#39;", "'", 1)
				retval := Mfunc.StringReplace(retval, "&lt;", "<", 1)
				retval := Mfunc.StringReplace(retval, "&gt;", ">",1)
				retval := Mfunc.StringReplace(retval, "&#44;", ",",1)
				
		} catch e {
			ex := new MfException(MfString.Format(MfEnvironment.Instance.GetResourceString("Exception_Error"), A_ThisFunc), e)
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
		return retval
	}
	
/*
	Function: Encode(str)
		Encode() Decodes Xml
	Parameters:
		str - The xml String to Encode, can be var of string or MfString object
	Returns:
		Returns string var containing the encoded xml
	Remarks:
		If str value is null or Empty the MfString.Empty is returned
	Throws:
		Throws MfException on any caught errors
	Example:
		> ToXml() {
		> 	retval := ""
		> 	try {
		> 			sXml := new MfString("<replacement>")
		> 			Indent := 1
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialogtype>", Indent))
		> 			sXml.Append(this.m_DialogType)
		> 			sXml.Append("</dialogtype>")
		> 			
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialogtitle>", Indent))
		> 			sXml.Append(XmlHelper.Encode(this.m_DialogTitle))
		> 			sXml.Append("</dialogtitle>")
		> 			
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialogtext>", Indent))
		> 			sXml.Append(XmlHelper.Encode(this.m_DialogText))
		> 			sXml.Append("</dialogtext>")
		> 			
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialoginitialvalue>", Indent))
		> 			sXml.Append(XmlHelper.Encode(this.m_DialogInitialValue))
		> 			sXml.Append("</dialoginitialvalue>")
		> 			
		> 			sXml.AppendLine("</replacement>")
		> 			retval := sXml.Value
		> 	} catch e {
		> 		ex := new MfException(MfString.Format(MfEnvironment.Instance.GetResourceString("Exception_Error"), A_ThisFunc), e)
		> 		ex.Source := A_ThisFunc
		> 		ex.File := A_LineFile
		> 		ex.Line := A_LineNumber
		> 		throw ex
		> 	}
		> 	return retval
		> }
*/
	Encode(str)
	{
		if(MfString.IsNullOrEmpty(str)) {
			return MfString.Empty
		}
		retval := MfString.GetValue(str)
		try {
			
			retval := Mfunc.StringReplace(retval, "&","&amp;", 1)
			retval := Mfunc.StringReplace(retval, """","&quot;", 1)
			retval := Mfunc.StringReplace(retval, "'","&#39;", 1)
			retval := Mfunc.StringReplace(retval, "<","&lt;", 1)
			retval := Mfunc.StringReplace(retval, ">","&gt;", 1)
			
			
		} catch e {
			ex := new MfException(MfString.Format(MfEnvironment.Instance.GetResourceString("Exception_Error"), A_ThisFunc), e)
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
		return retval
	}
	
;{ IndentString
/*
	Function: IndentString(str, indent)
		IndentString() Indents string with tabs
	Parameters:
		str - str can be a var containing string or an instance of MfString object.  
		indent - The ammount of tabs to indent by. Can be a var containing Integer or an instance of MfInteger object.  
		indentChar - the String used to indent with. Default it a Tab Char. Can be a var containing string or an instance of MfString object.  
	Remarks:
		Useful for intenting xml or html type string
	Returns:
		If *str* is MfString Instace the a MfString is returned with indent appended to the start of each line
		elsewise Returns String var in indent appended to the start of each line.
	Throws:
		Throws MfException on general errors.
	Example:
		> ToXml() {
		> 	retval := ""
		> 	try {
		> 			sXml := new MfString("<replacement>")
		> 			Indent := 1
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialogtype>", Indent))
		> 			sXml.Append(this.m_DialogType)
		> 			sXml.Append("</dialogtype>")
		> 			
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialogtitle>", Indent))
		> 			sXml.Append(XmlHelper.Encode(this.m_DialogTitle))
		> 			sXml.Append("</dialogtitle>")
		> 			
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialogtext>", Indent))
		> 			sXml.Append(XmlHelper.Encode(this.m_DialogText))
		> 			sXml.Append("</dialogtext>")
		> 			
		> 			sXml.AppendLine(XmlHelper.IndentString("<dialoginitialvalue>", Indent))
		> 			sXml.Append(XmlHelper.Encode(this.m_DialogInitialValue))
		> 			sXml.Append("</dialoginitialvalue>")
		> 			
		> 			sXml.AppendLine("</replacement>")
		> 			retval := sXml.Value
		> 	} catch e {
		> 		ex := new MfException(MfString.Format(MfEnvironment.Instance.GetResourceString("Exception_Error"), A_ThisFunc), e)
		> 		ex.Source := A_ThisFunc
		> 		ex.File := A_LineFile
		> 		ex.Line := A_LineNumber
		> 		throw ex
		> 	}
		> 	return retval
		> }	
*/
	IndentString(str, indent, indentChar="`t") {
		result := Null
		try
		{
			if (MfString.IsNullOrEmpty(str)) {
				return MfString.Empty
			}
			_indent := MfInteger.GetValue(indent)
			if (_indent <= 0) {
				return str
			}
			TabChar := ""
			inChar := MfString.GetValue(indentChar)
			Loop, %_indent%
			{
				TabChar .= inChar
			}
			if (MfObject.IsObjInstance(str, MfString)) {
				; we are using an instance of MfString so let proceed on an object way
				tmpValue := str.Value
				; test using regx to see if this is a mulit-line string.
				FirstMatchNum := tmpValue ~= "\R"
				if (FirstMatchNum) {
					; we have a multiline string
					newStr := ""
					Loop, Parse, tmpValue, `n
					{
						newStr .= MfString.Format("{0}{1}",TabChar, A_LoopField)
					}
					; newStr should have tabs appended on the start of each line.
					; just in case we will test that newStr has a value
					result := new MfString("", str.ReturnAsObject) ; create a new MfString instance and set it return type the same a the current str object
					if (newStr) {
						result.Value := newStr
					} else {
						result.Value := TabChar . tmpValue
					}
				} else {
					result := new MfString("", str.ReturnAsObject) ; create a new MfString instance and set it return type the same a the current str object
					result.Value := TabChar . tmpValue ; add tabs to the start of string and assign back to MfString instance value.
				}
			} else {
				tmpValue := str
				; test using regx to see if this is a mulit-line string.
				FirstMatchNum := tmpValue ~= "\R"
				if (FirstMatchNum) {
					; we have a multiline string
					newStr := ""
					Loop, Parse, tmpValue, `n
					{
						newStr .= MfString.Format("{0}{1}",TabChar, A_LoopField)
					}
					; newStr should have tabs appended on the start of each line.
					; just in case we will test that newStr has a value
					if (newStr) {
						result := newStr
					} else {
						result := TabChar . tmpValue
					}
				} else {
					result := TabChar . tmpValue ; add tabs to the start of string and assign back to result
				}
			}
			
		} catch e {
			ex := new MfException(MfString.Format(MfEnvironment.Instance.GetResourceString("Exception_Error"), A_ThisFunc), e)
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
		
		return result
	}
; End:IndentString ;}
	/*
		Title: XPath Quick Reference

		License:
			- Version 3.14 <http://www.autohotkey.net/~polyethene/#xpath>
			- Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
	*/

	/*
		Function: xpath
			Selects nodes and attributes from a standard xpath expression.

		Parameters:
			doc - an xml object returned by xpath_load()
			step - a valid XPath 2.0 expression
			set - (optional) text content to replace the current selection

		Returns:
			The XML source of the selection.
			If the content was set to be modified the previous value will be returned.

		Remarks:
			Since multiple return values are seperated with a comma,
			any found within the text content will be entity escaped as &#44;.
			To get or set the text content of a node use the text function,
			e.g. /root/node/text(); this behaviour is always assumed within predicates.
			For performance reasons count() and last() do not update with the creation of new nodes
			so you may need to alter the results accordingly.
	*/
	xpath(ByRef doc, step, set = "") {
		static sc, scb = "" ; use EOT (\x04) as delimiter
		
		If step contains %scb% ; i.e. illegal character
			Return
		sid := scb . &doc . ":" ; should be unique identifier for current XML object
		If (InStr(step, "select:") == 1) { ; for quick selection
			stsl = 1
			StringTrimLeft, step, step, 7
		}
		If (InStr(step, "/") == 1)
			str = 1 ; root selected
		Else {
			StringGetPos, p, sc, %sid% ; retrieve previous path
			If ErrorLevel = 1
				t = /
			Else StringMid, t, sc, p += StrLen(sid) + 1, InStr(sc, scb, "", p + 2) - p
			step = %t%/%step%
		}
		
		; normalize path e.g. /root/node/../child/. becomes /root/child:
		step := RegExReplace(step, "(?<=^|/)(?:[^\[/@]+/\.{2}|\.)(?:/|$)|^.+(?=//)")
		
		If (str == 1 or stsl == 1) { ; if not relative path and no select:
			; remove last node and trailing attributes and functions:
			xpr := RegExReplace(step, (str == 1 and stsl != 1 ? "/(?:\w+:)?\w+(?:\[[^\]]*])?" : "")
				. "(?:/@.*?|/\w+\(\))*$")
			StringReplace, xpr, xpr, [-1], [1], All ; -1 become just 1
			StringReplace, xpr, xpr, [+1], [last()], All ; +1 becomes last()
			StringGetPos, p, sc, %sid%
			If ErrorLevel = 1
				sc = %sc%%sid%%xpr%%scb% ; add record or update as necessary:
			Else sc := SubStr(sc, 1, p += StrLen(sid)) . xpr . SubStr(sc, InStr(sc, scb, "", p))
		}
		
		; for unions call each operand seperately and join results:
		If (InStr(step, "|")) {
			StringSplit, s, step, |, `n`t �`r
			Loop, %s0%
				res .= XmlHelper.xpath(doc, s%A_Index%, set) . ","
			Return, SubStr(res, 1, -1)
		}
		Else If (InStr(step, "//") == 1) { ; for wildcard selectors use regex searching mode:
			StringTrimLeft, step, step, 2
			re = 1
			rew = 1
			xp = /(?:(?:\w+:)?\w+)*/
		}
		
		NumPut(160, doc, 0, "UChar") ; unmask variable
		
		; resolve xpath components to: absolute node path, attributes and predicates (if any)
		Loop, Parse, step, /
		{
			s = %A_LoopField%
			If (InStr(s, "*") == 1) ; regex mode for wildcards
			{
				re = 1
				s := "(?:\w+:)?\w+" . SubStr(s, 2)
			}
			Else If (InStr(s, "@") == 1) { ; if current step is attribute:
				StringTrimLeft, atr, s, 1
				Continue
			}
			StringGetPos, p, s, [ ; look for predicate opening [...]
			If ErrorLevel = 0
			{
				If s contains [+1],[-1] ; for child nodes record creation instructions in a list
				{
					If A_Index = 2 ; root node creation
					{
						StringLeft, t, s, p
						t = <%t%/:: ></%t%/>
						If (InStr(s, "+1")) {
							If doc =
								doc = .
							doc = %doc%%t%
						}
						Else doc = .%t%%doc%
						StringLeft, s, s, InStr(s, "[") - 1
					}
					Else {
						nw = %nw%%s%
						Continue
					}
				}
				Else { ; i.e. for conditional predicates
					
					If (InStr(s, "last()")) { ; finding last node
						StringLeft, t, s, p
						t := "<" . SubStr(xp, 2) . t . "/:: "
						If re ; with regex:
						{
							os = 0
							Loop
								If (!os := RegExMatch(doc, t, "", 1 + os)) {
									t = %A_Index%
									Break
								}
							t--
						}
						Else { ; otherwise using StringReplace
							StringReplace, doc, doc, %t%, %t%, UseErrorLevel
							t = %ErrorLevel%
						}
						If (RegExMatch(s, "i)last\(\)\s*\-\s*(\d+)", a)) ; i.e. [last() - 2]
							StringReplace, s, s, %a%, % t - a1
						Else StringReplace, s, s, last(), %t%
					}
					
					; concat. the predicate to the list against the current absolute path:
					ax = %ax%%xp%%s%
					StringLeft, s, s, p
				}
			}
			Else If (InStr(s, "()")) { ; if step is function, add to list
				fn = %fn%+%s% ; use + prefix to prevent overlapping naming conflicts
				Continue
			}
			; finally, if step is not any of the above, assume it's the name of a child node
			xp = %xp%%s%/ ; ... and add to list, forming the absolute path
		}
		
		If (xp == "" or xp == "/") ; i.e. error cases
			Return
		
		; remove initial root selector (/) as this is how the parser works by default:
		StringTrimLeft, xp, xp, 1
		StringTrimRight, ax, ax, 1
		
		StringTrimRight, nw, nw, 1
		
		ct = 0 ; counter
		os = 0 ; offset for main loop starts at zero
		Loop {
			; find offset of next element, and its closing tag offset:
			If re
				os := RegExMatch(doc, "<" . xp . ":: ", "", 1 + os)
					, osx := RegExMatch(doc, "</" . xp . ">", rem, os) + StrLen(rem)
			Else {
				StringGetPos, osx, doc, </%xp%>, , os := InStr(doc, "<" . xp . ":: ", true, 1 + os)
				osx += 4 + StrLen(xp)
			}
			If os = 0 ; stop looping when no more tags are found
				Break
			
			; predicate parser:
			If ax !=
			{
				sk = 0
				Loop, Parse, ax, ] ; for each predicate
				{
					; split components to: (1) path, (2) selector, (3) operator, (4) quotation char, (5) operand
					If (!RegExMatch(A_LoopField, "/?(.*?)\[(.+?)(?:\s*([<>!=]{1,2})\s*(['""])?(.+)(?(4)\4))?\s*$", a))
						Continue
					a1 = %a1%/
					If re
						RegExMatch(rem, "(?<=^</)" . a1, a1)
					
					If a2 is integer ; i.e. match only certain index
					{
						StringGetPos, t, a1, /, R2
						StringMid, t, a1, 1, t + 1
						t := InStr(SubStr(doc, 1, os), "<" . t . ":: ", true, 0)
						; extract parent node:
						StringMid, sub, doc, t, InStr(doc, ">", "", os) - t
						xpf := "<" . a1 . ":: "
						; get index of current element within parent node:
						StringReplace, sub, sub, %xpf%, %xpf%, UseErrorLevel
						If a2 != %ErrorLevel%
							sk = 1
						Continue
					}
					
					StringReplace, xp, xp, /, /, UseErrorLevel
					t = %ErrorLevel%
					StringReplace, a1, a1, /, /, UseErrorLevel
					
					 ; extract result for deep analysis
					If t = %ErrorLevel% ; i.e. /root/node[child='test']
						StringMid, sub, doc, os, osx - os
					Else StringMid, sub, doc
						 	, t := InStr(SubStr(doc, 1, os), "<" . a1 . ":: ", true, 0)
						 	, InStr(doc, "</" . a1 . ">", true, t) + 1
					
					If a2 = position()
						sub = %i%
					Else If (InStr(a2, "@") == 1) ; when selector is an attribute:
					 RegExMatch(SubStr(sub, 1, InStr(sub, ">"))
							, a3 == "" ? "\b" . SubStr(a2, 2) . "=([""'])[^\1]*?\1"
							: "\b(?<=" . SubStr(a2, 2) . "=([""']))[^\1]+?(?=\1)", sub)
					Else ; otherwise child node:
					{
						If a2 = . ; if selector is current node don't append to path:
							a2 = /
						Else a2 = %a2%/
						StringMid, sub, sub
							, t := InStr(sub, ">", "", InStr(sub, "<" . a1 . a2 . ":: ", true) + 1) + 1
							, InStr(sub, "</" . a1 . a2 . ">", true) - t
					}
					
					; dynamic mini expression evaluator:
					sk += !(a3 == "" ? (sub != "")
						: a3 == "=" ? sub == a5
						: a3 == "!=" ? sub != a5
						: a3 == ">" ? sub > a5
						: a3 == ">=" ? sub >= a5
						: a3 == "<" ? sub < a5
						: a3 == "<=" ? sub <= a5)
				}
				If sk != 0 ; if conditions were not met for this result, skip it
					Continue
			}
			
			If nw != ; for node creation
			{
				If re
					nwp := SubStr(rem, 3, -1)
				Else nwp = %xp%
				Loop, Parse, nw, ]
				{
					StringLeft, nwn, A_LoopField, InStr(A_LoopField, "[") - 1
					nwn = %nwn%/
					nwt = <%nwp%%nwn%:: ></%nwp%%nwn%>
					If (t := InStr(A_LoopField, "-1")
						? InStr(doc, ">", "", InStr(doc, "<" . nwp . ":: ", true, os) + 1) + 1
						: InStr(doc, "</" . nwp . ">", true, os))
						os := t
					StringLen, osx, nwt
					osx += os
					doc := SubStr(doc, 1, os - 1) . nwt . SubStr(doc, os)
					nwp = %nwp%%nwn%
				}
				StringLen, t, nwp
				If (InStr(fn, "+text()") and atr == "")
					os += t + 5, osx -= t + 3
			}
			
			If atr !=
			{
				; extract attribute offsets, with surrounding declaration if text() is not used:
				If (t := RegExMatch(SubStr(doc, os, InStr(doc, ">", "", os) - os), InStr(fn, "+text()")
					? "(?<=\b" . atr . "=([""']))[^\1]*?(?=\1)"
					: "\b" . atr . "=([""'])[^\1]*?\1", rem))
					os += t - 1, osx := os + StrLen(rem)
				Else { ; create attribute
					os := InStr(doc, ">", "", os + 1)
						, doc := SubStr(doc, 1, os - 1) . " " . atr . "=""""" . SubStr(doc, os)
						, osx := ++os + StrLen(atr) + 3
					If (InStr(fn, "+text()"))
						osx := os += StrLen(atr) + 2
				}
			}
			Else If (InStr(fn, "+text()") and nw == "") ; for text content:
				os := InStr(doc, ">", "", os) + 1, osx := InStr(doc, re ? rem : "</" . xp . ">", true, os)
			
			If InStr(fn, "+index-of()") ; get index rather than content
				sub = %A_Index% 
			Else StringMid, sub, doc, os, osx - os ; extract result
			
			If (InStr(fn, "+count()")) ; increment counter if count() function is used
				ct++
			Else res = %res%%sub%, ; ... and concat to list
			
			If (set != "" or InStr(fn, "+remove()")) ; modify or remove...
				setb = %setb%%os%.%osx%| ; mark for modification
		}
		
		If setb !=
		{
			If (InStr(set, "node:") == 1) {
				set := SubStr(XmlHelper.xpath(doc, SubStr(set, 6) . "/rawsrc()"), 2)
				StringReplace, set, set, <, <%xp%, All
				StringReplace, set, set, <%xp%/, </%xp%, All
				NumPut(160, doc, 0, "UChar")
			}
			StringTrimRight, setb, setb, 1
			Loop, Parse, setb, |
			{
				StringSplit, setp, A_LoopField, .
				StringLen, t, xp
				If (InStr(fn, "+append()"))
					setp2 := setp1 := setp2 - t - 3
				Else If (InStr(fn, "+prepend()"))
					setp2 := setp1 := InStr(doc, ">", "", setp1) + 2
				doc := SubStr(doc, 1, setp1 - 1) . set . SubStr(doc, setp2) ; dissect then insert new value
			}
		}
		
		If (InStr(fn, "+count()"))
			res = %ct%, ; trailing char since SubStr is used below
		
		nsid := scb . &doc . ":" ; update sid as necessary
		If nsid != %sid%
			StringReplace, sc, sc, %sid%, %nsid%
		
		NumPut(0, doc, 0, "UChar") ; remask variable to prevent external editing
		StringTrimRight, res, res, 1
		If (InStr(fn, "+rawsrc()")) {
			StringTrimLeft, t, xpr, 1
			StringReplace, res, res, <%t%/, <, All
			StringReplace, res, res, </%t%, <, All
			StringReplace, res, res, `,, `,%scb%, All
			Return, scb . res
		}
		; remove trailing comma and absolute paths from result before returning:
		Return, RegExReplace(res, "S)(?<=<)(\/)?(?:(\w+)\/)+(?(1)|:: )", "$1$2")
	}

	/*
		Function: xpath_save
			Saves an XML document to file or returns the source.

		Parameters:
			doc - an xml object returned by xpath_load()
			src - (optional) a path to a file where the XML document should be saved;
				if the file already exists it will be replaced

		Returns:
			False if there was an error in saving the document, true otherwise.
			If the src parameter is left blank the source code of the document is returned instead.
	*/
	xpath_save(ByRef doc, src = "") {
		xml := RegExReplace(SubStr(doc, 2), "S)(?<=<)(\/)?(?:(\w+)\/)+(?(1)|:: )", "$1$2") ; remove metadata
		xml := RegExReplace(xml, "<([\w:]+)([^>]*)><\/\1>", "<$1$2 />") ; fuse empty nodes
		;xml := RegExReplace(xml, " (?=(?:\w+:)?\w+=['""])") ; remove prepending whitespace on attributes
		xml := RegExReplace(xml, "^\s+|\s+$") ; remove start and leading whitespace
		StringReplace, xml, xml, `r, , All ; normalize linefeeds:
		StringReplace, xml, xml, `n, `r`n, All
		sp := "  "
		StringLen, sl, sp
		s =
		VarSetCapacity(sxml, StrLen(xml) * 1.1)
		Loop, Parse, xml, <, `n`t 	�`r
		{
			If A_LoopField =
				Continue
			If (sb := InStr(A_LoopField, "/") == 1)
				StringTrimRight, s, s, sl
			sxml = %sxml%`n%s%<%A_LoopField%
			If sb
				StringTrimRight, s, s, sl
			If (InStr(A_LoopField, "?") != 1 and InStr(A_LoopField, "!") != 1
				and !InStr(A_LoopField, "/>"))
				s .= sp
		}
		StringTrimLeft, sxml, sxml, 1
		sxml := RegExReplace(sxml, "(\n(?:" . sp . ")*<((?:\w+:)?\w+\b)[^<]+?)\n(?:"
			. sp . ")*</\2>", "$1</$2>")
		If InStr(xml, "<?xml") != 1 ; add processor instruction if there isn't any:
			xml = <?xml version="1.0" encoding="iso-8859-1"?>`r`n%xml%
		If src = ; if save path not specified return the XML document:
			Return, sxml
		FileDelete, %src% ; delete existing file
		FileAppend, %sxml%, %src% ; create new one
		Return, ErrorLevel ; return errors, if any
	}

	/*
		Function: xpath_load
			Loads an XML document.

		Parameters:
			doc - a reference to the loaded XML file as a variable, to be used in other functions
			src - (optional) the document to load, this can be a file name or a string,
				if omitted the first paramter is used as the source

		Returns:
			False if there was an error in loading the document, true otherwise.
	*/
	xpath_load(ByRef doc, src = "") {
		If src = ; if source is empty assume the out variable is the one to be loaded
			src = %doc%
		Else If FileExist(src) ; otherwise read from file (if it exists)
			FileRead, src, %src%
		If src not contains <,>
			Return, false
		; combined expressions slightly improve performance:
		src := RegExReplace(src, "<((?:\w+:)?\w+\b)([^>]*)\/\s*>", "<$1$2></$1>") ; defuse nodes
			, VarSetCapacity(doc, VarSetCapacity(xml, StrLen(src) * 1.5) * 1.1) ; pre-allocate enough space
		Loop, Parse, src, < ; for each opening tag:
		{
			If (A_Index == 2 and InStr(A_LoopField, "?xml") == 1)
				Continue
			Else If (InStr(A_LoopField, "?") == 1) ; ignore all other processor instructions
				xml = %xml%<%A_LoopField%
			Else If (InStr(A_LoopField, "![CDATA[") == 1) { ; escape entities in CDATA sections
				cdata := SubStr(A_LoopField, 9, -3)
				StringReplace, cdata, cdata, ", &quot;, All
				StringReplace, cdata, cdata, &, &amp;, All
				StringReplace, cdata, cdata, ', &apos;, All
				StringReplace, cdata, cdata, <, &lt;, All
				StringReplace, cdata, cdata, >, &gt;, All
				xml = %xml%%cdata% 
			}
			Else If (!pos := RegExMatch(A_LoopField, "^\/?(?:\w+:)?\w+", tag)) ; if this isn't a valid tag:
			{
				If A_LoopField is not space
					xml = %xml%&lt;%A_LoopField% ; convert to escaped entity value
			}
			Else {
				StringMid, ex, A_LoopField, pos + StrLen(tag) ; get tag name
				If InStr(tag, "/") = 1 { ; if this is a closing tag:
					xml = %xml%</%pre%%ex% ; close tag
					StringGetPos, pos, pre, /, R2
					StringLeft, pre, pre, pos + 1
				}
				Else {
					pre = %pre%%tag%/
					xml = %xml%<%pre%:: %ex%
				}
			}
		}
		StringReplace, doc, xml, `,, &#44;, All ; entity escape commas (which are used as array delimiters)
		NumPut(0, doc := " " . doc, 0, "UChar") ; mask variable from text display with nullbyte
		Return, true ; assume sucessful load by this point
	}
}
/*!
	End of class
*/