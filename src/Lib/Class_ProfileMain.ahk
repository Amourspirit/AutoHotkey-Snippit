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


	class ProfileMain extends profile
	{

		m_xml := Null

		__New(args*)
		{
			base.__New(args*)
			this.m_isInherited := this.base.__Class != "ProfileMain"
		}
		
		init(ProfileFile)
		{
			if(MfString.IsNullOrEmpty(ProfileFile)) {
				ex := new MfArgumentNullException("ProfileFile")
				ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
				throw ex
			}
			if(FileExist(ProfileFile)) {
				this.m_xml := ProfileFile
			} else {
				this.m_xml := MfString.Format("{0}\{1}\{2}\{3}", A_AppData, Script.DataFolder, "Profiles", ProfileFile)
			}

			if (!FileExist(this.m_xml)) {
				ex := new MfFileNotFoundException(SnipyRI.Instance.GetResourceString("FileNotFoundException_XML"
					, MfEnvironment.Instance.NewLine, this.m_xml))
				ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
				throw ex
			}
			this.m_BaseFolder := MfString.Format("{0}\{1}", A_AppData, Script.DataFolder)

			this.m_BaseFolderXml := MfString.Format("{0}\{1}", this.m_BaseFolder, "xml")
			this.m_BaseFolderPlugins := MfString.Format("{0}\{1}", this.m_BaseFolder, "Plugins")
			this.m_BaseFolderSnips := MfString.Format("{0}\{1}", this.m_BaseFolder, "Snips")

			this.ParseXml(this.m_xml)

			if (!FileExist(this.m_BaseFolder)) {
				; if the base folder does not exist yet 
				; the created it and flag for a restart of the app
				this.m_ReloadRequired := true
				Mfunc.FileCreateDir(this.m_BaseFolder)
			}
			if (!FileExist(this.m_BaseFolderXml)) {
				Mfunc.FileCreateDir(this.m_BaseFolderXml)
			}
			if (!FileExist(this.m_BaseFolderPlugins)) {
				; if the base plugin folder does not exist yet 
				; the created it and flag for a restart of the app
				this.m_ReloadRequired := true
				Mfunc.FileCreateDir(this.m_BaseFolderPlugins)
			}
			if (!FileExist(this.m_BaseFolderSnips)) {
				Mfunc.FileCreateDir(this.m_BaseFolderSnips)
			}
			if (!FileExist(this.PathMainData)) {
				Mfunc.FileCreateDir(this.PathMainData)
			}
			
			if (!FileExist(this.PathPlugin)) {
				Mfunc.FileCreateDir(this.PathPlugin)
			}
			if (!FileExist(this.PathSnips)) {
				Mfunc.FileCreateDir(this.PathSnips)
			}
			
			this._init()
		}
;{ 	_init
	_init()
	{
		if (!FileExist(this.m_BaseFolder)) {
			; if the base folder does not exist yet 
			; the created it and flag for a restart of the app
			this.m_ReloadRequired := true
			Mfunc.FileCreateDir(this.m_BaseFolder)
		}
		if (!FileExist(this.m_BaseFolderXml)) {
			Mfunc.FileCreateDir(this.m_BaseFolderXml)
		}
		if (!FileExist(this.m_BaseFolderPlugins)) {
			; if the base plugin folder does not exist yet 
			; the created it and flag for a restart of the app
			this.m_ReloadRequired := true
			Mfunc.FileCreateDir(this.m_BaseFolderPlugins)
		}
		if (!FileExist(this.m_BaseFolderSnips)) {
			Mfunc.FileCreateDir(this.m_BaseFolderSnips)
		}
		if (!FileExist(this.PathMainData)) {
			Mfunc.FileCreateDir(this.PathMainData)
		}
		
		if (!FileExist(this.PathPlugin)) {
			Mfunc.FileCreateDir(this.PathPlugin)
		}
		if (!FileExist(this.PathSnips)) {
			Mfunc.FileCreateDir(this.PathSnips)
		}

	}
; 	End:_init ;}

;{ 		MainData
	; Folder name or path to xml files that contain the main data for the snippits
	MainData[]
	{
		get {
			return this.codeLanguage.paths.mainData
		}
		set {
			this.codeLanguage.paths.mainData := value
			return this.codeLanguage.paths.mainData
		}
	}
; 		End:MainData ;}
;{ 		PathMainData
	m_PathMainData := Null
	; Path to the xml files that contain the main data for the snippits
	PathMainData[]
	{
		get {
			if(MfString.IsNullOrEmpty(this.m_PathMainData)) {
				if (FileExist(this.MainData)) {
					this.m_PathMainData := this.MainData
				} else {
					this.m_PathMainData := MfString.Format("{0}\{1}", this.m_BaseFolderXml, this.MainData)
				}
			}
			
			return this.m_PathMainData
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:PathMainData ;}
;{ 		PathPlugin
	m_PathPlugin := Null
	; Path to the plugins for the currently select language
	PathPlugin[]
	{
		get {
			if(MfString.IsNullOrEmpty(this.m_PathPlugin)) {
				strPlugin := this.codeLanguage.paths.plugin
				if (MfString.IsNullOrEmpty(strPlugin))
				{
					strPlugin := this.codeLanguage.paths.mainData
				}
				if (FileExist(strPlugin)) {
					this.m_PathPlugin := strPlugin
				} else {
					
					this.m_PathPlugin := MfString.Format("{0}\{1}", this.m_BaseFolderPlugins, strPlugin)
				}
			}
			return this.m_PathPlugin
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:PathPlugin ;}
;{ 		PathSnips
	m_PathSnips		:= Null
	; Path to sippit files for the current selected Language
	PathSnips[]
	{
		get {
			if(MfString.IsNullOrEmpty(this.m_PathSnips))
			{
				snips := this.codeLanguage.paths.snips
				if(MfString.IsNullOrEmpty(snips))
				{
					snips := this.codeLanguage.paths.mainData
				}
				else if (FileExist(snips))
				{
					this.m_PathSnips := snips
					return this.m_PathSnips
				}
				this.m_PathSnips := MfString.Format("{0}\{1}", this.m_BaseFolderSnips, snips)
				
			}
			return this.m_PathSnips
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:PathSnips ;}
;{ 		PathSnips
	m_PathSnipsInline := Null
	; Path to sippit files for the current selected Language
	PathSnipsInline[]
	{
		get {
			if(MfString.IsNullOrEmpty(this.m_PathSnipsInline)) {
				this.m_PathSnipsInline := MfString.Format("{0}\{1}", this.PathSnips, "Inline")
			}
			return this.m_PathSnipsInline
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:PathSnips ;}
;{ 		BaseFolder
	m_BaseFolder		:= Null
	; Base Folder in AppData romaing such as C:\Users\myname\AppData\Roaming\AhkSnippyTool
	BaseFolder[]
	{
		get {
			return this.m_BaseFolder
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:BaseFolder ;}
;{ 		BaseFolderXml
	m_BaseFolderXml		:= Null
	; Base Folder for Xml data such as C:\Users\myname\AppData\Roaming\AhkSnippyTool\xml
	BaseFolderXml[]
	{
		get {
			return this.m_BaseFolderXml
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:BaseFolderXml ;}
;{ 		BaseFolderPlugins
	m_BaseFolderPlugins		:= Null
	; Base Folder for Xml data such as C:\Users\myname\AppData\Roaming\AhkSnippyTool\Plugins
	BaseFolderPlugins[]
	{
		get {
			return this.m_BaseFolderPlugins
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:BaseFolderPlugins ;}
;{ 		BaseFolderSnips
	m_BaseFolderSnips		:= Null
	BaseFolderSnips[]
	{
		get {
			return this.m_BaseFolderSnips
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:BaseFolderSnips ;}
;{ 		ReloadRequired
	m_ReloadRequired := false
	; Property that gets if a script reload is needed.
	ReloadRequired[]
	{
		get {
			return this.m_ReloadRequired
		}
		set {
			ex := new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Readonly_Property"))
			ex.SetProp(A_LineFile, A_LineNumber, A_ThisFunc)
			throw ex
		}
	}
; 		End:ReloadRequired ;}
    
    IsObjInstance(obj, objType = "")
    {
        return MfObject.IsObjInstance(obj, objType)
    }
    
    ToString()
    {
        return base.ToString()
    }
}