#define use_mfinstalled
#define use_miniframework
#define use_autohotkey
#define use_msi45
#define use_dotnetfx46

#define MyAppName "AutoHotkey Snippit"
#define MyAppVersion "0.8.0.0"
#define MyAppPublisher "Paul Moss"
#define MyAppURL "https://github.com/Amourspirit/AutoHotkey-Snippit"
#define BaseAhk "\AutoHotkey\Scripts"
#define DataFolder "\AutoHotkey Snippit"
#define MainScriptFile "AhkSnippyTool.ahk"
#define MainLaunchFile "AhkSnippitLaunch.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{5BA79245-6BD6-4696-98DD-0FA1C45CEBE6}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
;DefaultDirName={userdocs}\AutoHotkey\Lib\{#MyAppName}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=License.txt
OutputDir={#SourcePath}\bin
OutputBaseFilename=AutoHotkeySnippitSetup
Compression=lzma
SolidCompression=yes
SourceDir=..\src
ShowLanguageDialog=no
LanguageDetectionMethod=none

ArchitecturesAllowed=x86 x64 ia64
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
ArchitecturesInstallIn64BitMode=x64 ia64
; Note: We don't set ProcessorsAllowed because we want this
; installation to run on all architectures (including Itanium,
; since it's capable of running 32-bit code too).
AppCopyright=Copyright (c) 2015, 2018 Paul Moss
UninstallDisplayIcon={pf}\{#MyAppName}\icons\icon.ico

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Files]
Source: "AhkSnippyTool.ahk"; DestDir: "{pf}\{#MyAppName}"; Flags: ignoreversion
Source: "bin\x86\AhkSnippitLaunch.exe"; DestDir: "{pf}\{#MyAppName}"; Flags: ignoreversion; Check: not Is64BitInstallMode
Source: "bin\x64\AhkSnippitLaunch.exe"; DestDir: "{pf}\{#MyAppName}"; Flags: ignoreversion; Check: Is64BitInstallMode
Source: "bin\x86\AutoHotkey Snippit.chm"; DestDir: "{pf}\{#MyAppName}"; Flags: ignoreversion
Source: "License.txt"; DestDir: "{pf}\{#MyAppName}"; Flags: ignoreversion

Source: "Lib\Class_AppSettings.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_BlackWhiteList.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_ProfileMain.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_Settings.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_SnippyResourceManager.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_SnipyRI.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_XmlHelper.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_AhkHotkeys.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Inc_cInputBox.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Inc_cInputList.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Inc_Debug.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Inc_Partial_Class_Debug.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Inc_public.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Inc_Script.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\profile.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\scriptobj.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\xpath.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Class_ErrorBoxResult.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
Source: "Lib\Inc_HandleError.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion
    
Source: "Resource\Resource_Core_en-US.dll"; DestDir: "{pf}\{#MyAppName}\Resource"; Flags: ignoreversion

Source: "bin\x86\AHKSnipitLib.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: not Is64BitInstallMode
Source: "bin\x86\CommandManager.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: not Is64BitInstallMode
Source: "bin\x86\INIFileParser.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: not Is64BitInstallMode
Source: "bin\x86\Z.IconLibrary.Silk.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: not Is64BitInstallMode
Source: "bin\x86\HotList.exe"; DestDir: "{pf}\{#MyAppName}\bin"; Check: not Is64BitInstallMode
Source: "bin\x86\ProfileSwap.exe"; DestDir: "{pf}\{#MyAppName}\bin"; Check: not Is64BitInstallMode
Source: "bin\x86\PluginWriter.exe"; DestDir: "{pf}\{#MyAppName}\bin"; Check: not Is64BitInstallMode

Source: "bin\x64\AHKSnipitLib.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: Is64BitInstallMode
Source: "bin\x64\CommandManager.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: Is64BitInstallMode
Source: "bin\x64\INIFileParser.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: Is64BitInstallMode
Source: "bin\x64\Z.IconLibrary.Silk.dll"; DestDir: "{pf}\{#MyAppName}\bin"; Check: Is64BitInstallMode
Source: "bin\x64\HotList.exe"; DestDir: "{pf}\{#MyAppName}\bin"; Check: Is64BitInstallMode
Source: "bin\x64\ProfileSwap.exe"; DestDir: "{pf}\{#MyAppName}\bin"; Check: Is64BitInstallMode
Source: "bin\x64\PluginWriter.exe"; DestDir: "{pf}\{#MyAppName}\bin"; Check: Is64BitInstallMode

Source: "icons\icon.ico"; DestDir: "{pf}\{#MyAppName}"
Source: "icons\icon.ico"; DestDir: "{pf}\{#MyAppName}\icons"
Source: "icons\pause.ico"; DestDir: "{pf}\{#MyAppName}\icons"
Source: "icons\suspend.ico"; DestDir: "{pf}\{#MyAppName}\icons"

; external flags must be used on file entries in order to use constants such as {userdocs}
; Source: "{userdocs}\AutoHotkey\Lib\Class_ErrorBoxResult.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion external
; Source: "{userdocs}\AutoHotkey\Lib\Inc_HandleError.ahk"; DestDir: "{pf}\{#MyAppName}\Lib"; Flags: ignoreversion external

Source: "..\Install-Includes\Profiles\*.xml"; DestDir: "{userappdata}{#DataFolder}\Profiles";
Source: "..\Install-Includes\xml\Windows Global\*.xml"; DestDir: "{userappdata}{#DataFolder}\xml\Windows Global";
Source: "..\Install-Includes\xml\AutoHotkey\*.xml"; DestDir: "{userappdata}{#DataFolder}\xml\AutoHotkey";



[Dirs]
Name: "{userappdata}{#DataFolder}"
Name: "{userappdata}{#DataFolder}\Plugins"
Name: "{userappdata}{#DataFolder}\Plugins\Windows Global"
Name: "{userappdata}{#DataFolder}\Profiles"
Name: "{userappdata}{#DataFolder}\Snips"
Name: "{userappdata}{#DataFolder}\xml"

[INI]
Filename:"{userappdata}{#DataFolder}\settings.ini"; Section: "PROFILE"; Key: "current"; String: "Windows Global.xml"; Flags: createkeyifdoesntexist
Filename:"{userappdata}{#DataFolder}\settings.ini"; Section: "APPS"; Key: "hotlist"; String: "{pf}\{#MyAppName}\bin\HotList.exe"; Flags: createkeyifdoesntexist
Filename:"{userappdata}{#DataFolder}\settings.ini"; Section: "APPS"; Key: "swap"; String: "{pf}\{#MyAppName}\bin\ProfileSwap.exe"; Flags: createkeyifdoesntexist
Filename:"{userappdata}{#DataFolder}\settings.ini"; Section: "APPS"; Key: "writer"; String: "{pf}\{#MyAppName}\bin\PluginWriter.exe"; Flags: createkeyifdoesntexist

Filename:"{userappdata}{#DataFolder}\app.ini"; Section: "SCRIPT"; Key: "path"; String: "{pf}\{#MyAppName}\{#MainScriptFile}"; Flags: createkeyifdoesntexist
Filename:"{userappdata}{#DataFolder}\app.ini"; Section: "SCRIPT"; Key: "MainScriptFile"; String: "{#MainScriptFile}"; Flags: createkeyifdoesntexist
Filename:"{userappdata}{#DataFolder}\app.ini"; Section: "SCRIPT"; Key: "LaunchPath"; String: "{pf}\{#MyAppName}\{#MainLaunchFile}"; Flags: createkeyifdoesntexist

Filename:"{userappdata}{#DataFolder}\app.ini"; Section: "SCRIPT"; Key: "load_state"; String: "0"; Flags: createkeyifdoesntexist
Filename:"{userappdata}{#DataFolder}\app.ini"; Section: "SCRIPT"; Key: "version"; String: "{#MyAppVersion}"; Flags: createkeyifdoesntexist

Filename:"{userappdata}{#DataFolder}\app.ini"; Section: "WRITER"; Key: "path"; String: "{pf}\{#MyAppName}\{#MainLaunchFile}"; Flags: createkeyifdoesntexist
Filename:"{userappdata}{#DataFolder}\app.ini"; Section: "WRITER"; Key: "exitcode"; String: "0"; Flags: createkeyifdoesntexist
[ICONS]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MainScriptFile}"; IconFilename: "{app}\icon.ico"
Name: "{group}\Hot List"; Filename: "{app}\bin\HotList.exe"
Name: "{group}\Profile Swap"; Filename: "{app}\bin\ProfileSwap.exe"
Name: "{group}\License"; Filename: "{app}\License.txt"
Name: "{group}\Help"; Filename: "{app}\AutoHotkey Snippit.chm"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"

[RUN]
; main launch file will write the files needed for the current profile and exit
Filename: "{app}\{#MainLaunchFile}"
; The Main launch file will now force the main script to start and not run the plugin writer
Filename: "{app}\{#MainLaunchFile}"; Parameters: "/FORCESTART /NOWRITE"; Description: "Run {#MyAppName}"; Flags: postinstall nowait skipifsilent

[CODE]

// shared code for installing the products
#include "scripts\products.iss"

// helper functions
// include custom function to explode string into string arrays. Same as split
// explodefunc.iss must be included before stringversion.iss
#include "scripts\products\explodefunc.iss"
#include "scripts\products\stringversion.iss"

//include "scripts\products\listVersion.iss"
#include "scripts\products\winversion.iss"
#include "scripts\products\fileversion.iss"
#include "scripts\products\dotnetfxversion.iss"

#include "scripts\products\mfinstalled.iss"
    
// actual products
#ifdef use_autohotkey
#include "scripts\products\autohotkey.iss"
#endif

#ifdef use_miniframework
#include "scripts\products\miniframework.iss"
#endif


#ifdef use_iis
#include "scripts\products\iis.iss"
#endif

#ifdef use_kb835732
#include "scripts\products\kb835732.iss"
#endif

#ifdef use_msi20
#include "scripts\products\msi20.iss"
#endif
#ifdef use_msi31
#include "scripts\products\msi31.iss"
#endif
#ifdef use_msi45
#include "scripts\products\msi45.iss"
#endif

#ifdef use_ie6
#include "scripts\products\ie6.iss"
#endif

#ifdef use_dotnetfx11
#include "scripts\products\dotnetfx11.iss"
#include "scripts\products\dotnetfx11sp1.iss"
#ifdef use_dotnetfx11lp
#include "scripts\products\dotnetfx11lp.iss"
#endif
#endif

#ifdef use_dotnetfx20
#include "scripts\products\dotnetfx20.iss"
#include "scripts\products\dotnetfx20sp1.iss"
#include "scripts\products\dotnetfx20sp2.iss"
#ifdef use_dotnetfx20lp
#include "scripts\products\dotnetfx20lp.iss"
#include "scripts\products\dotnetfx20sp1lp.iss"
#include "scripts\products\dotnetfx20sp2lp.iss"
#endif
#endif

#ifdef use_dotnetfx35
//#include "scripts\products\dotnetfx35.iss"
#include "scripts\products\dotnetfx35sp1.iss"
#ifdef use_dotnetfx35lp
//#include "scripts\products\dotnetfx35lp.iss"
#include "scripts\products\dotnetfx35sp1lp.iss"
#endif
#endif

#ifdef use_dotnetfx40
#include "scripts\products\dotnetfx40client.iss"
#include "scripts\products\dotnetfx40full.iss"
#endif

#ifdef use_dotnetfx46
#include "scripts\products\dotnetfx46.iss"
#endif

#ifdef use_wic
#include "scripts\products\wic.iss"
#endif

#ifdef use_msiproduct
#include "scripts\products\msiproduct.iss"
#endif
#ifdef use_vc2005
#include "scripts\products\vcredist2005.iss"
#endif
#ifdef use_vc2008
#include "scripts\products\vcredist2008.iss"
#endif
#ifdef use_vc2010
#include "scripts\products\vcredist2010.iss"
#endif
#ifdef use_vc2012
#include "scripts\products\vcredist2012.iss"
#endif
#ifdef use_vc2013
#include "scripts\products\vcredist2013.iss"
#endif
#ifdef use_vc2015
#include "scripts\products\vcredist2015.iss"
#endif

#ifdef use_mdac28
#include "scripts\products\mdac28.iss"
#endif
#ifdef use_jet4sp8
#include "scripts\products\jet4sp8.iss"
#endif

#ifdef use_sqlcompact35sp2
#include "scripts\products\sqlcompact35sp2.iss"
#endif

#ifdef use_sql2005express
#include "scripts\products\sql2005express.iss"
#endif
#ifdef use_sql2008express
#include "scripts\products\sql2008express.iss"
#endif


function InitializeSetup(): boolean;
begin
	// initialize windows version
	initwinversion();
#ifdef use_autohotkey
   autohotkey('1.1.23')
#endif

#ifdef use_miniframework
  miniframework('0.4.0.0');
#endif



#ifdef use_iis
	if (not iis()) then exit;
#endif

#ifdef use_msi20
	msi20('2.0'); // min allowed version is 2.0
#endif
#ifdef use_msi31
	msi31('3.1'); // min allowed version is 3.1
#endif
#ifdef use_msi45
	msi45('4.5'); // min allowed version is 4.5
#endif
#ifdef use_ie6
	ie6('5.0.2919'); // min allowed version is 5.0.2919
#endif

#ifdef use_dotnetfx11
	dotnetfx11();
#ifdef use_dotnetfx11lp
	dotnetfx11lp();
#endif
	dotnetfx11sp1();
#endif

	// install .netfx 2.0 sp2 if possible; if not sp1 if possible; if not .netfx 2.0
#ifdef use_dotnetfx20
	// check if .netfx 2.0 can be installed on this OS
	if not minwinspversion(5, 0, 3) then begin
		msgbox(fmtmessage(custommessage('depinstall_missing'), [fmtmessage(custommessage('win_sp_title'), ['2000', '3'])]), mberror, mb_ok);
		exit;
	end;
	if not minwinspversion(5, 1, 2) then begin
		msgbox(fmtmessage(custommessage('depinstall_missing'), [fmtmessage(custommessage('win_sp_title'), ['XP', '2'])]), mberror, mb_ok);
		exit;
	end;

	if minwinversion(5, 1) then begin
		dotnetfx20sp2();
#ifdef use_dotnetfx20lp
		dotnetfx20sp2lp();
#endif
	end else begin
		if minwinversion(5, 0) and minwinspversion(5, 0, 4) then begin
#ifdef use_kb835732
			kb835732();
#endif
			dotnetfx20sp1();
#ifdef use_dotnetfx20lp
			dotnetfx20sp1lp();
#endif
		end else begin
			dotnetfx20();
#ifdef use_dotnetfx20lp
			dotnetfx20lp();
#endif
		end;
	end;
#endif

#ifdef use_dotnetfx35
	//dotnetfx35();
	dotnetfx35sp1();
#ifdef use_dotnetfx35lp
	//dotnetfx35lp();
	dotnetfx35sp1lp();
#endif
#endif

#ifdef use_wic
	wic();
#endif

	// if no .netfx 4.0 is found, install the client (smallest)
#ifdef use_dotnetfx40
	if (not netfxinstalled(NetFx40Client, '') and not netfxinstalled(NetFx40Full, '')) then
		dotnetfx40client();
#endif

#ifdef use_dotnetfx46
    dotnetfx46(50); // min allowed version is 4.5.0
#endif

#ifdef use_vc2005
	vcredist2005();
#endif
#ifdef use_vc2008
	vcredist2008();
#endif
#ifdef use_vc2010
	vcredist2010();
#endif
#ifdef use_vc2012
	vcredist2012();
#endif
#ifdef use_vc2013
	//SetForceX86(true); // force 32-bit install of next products
	vcredist2013();
	//SetForceX86(false); // disable forced 32-bit install again
#endif
#ifdef use_vc2015
	vcredist2015();
#endif

#ifdef use_mdac28
	mdac28('2.7'); // min allowed version is 2.7
#endif
#ifdef use_jet4sp8
	jet4sp8('4.0.8015'); // min allowed version is 4.0.8015
#endif

#ifdef use_sqlcompact35sp2
	sqlcompact35sp2();
#endif

#ifdef use_sql2005express
	sql2005express();
#endif
#ifdef use_sql2008express
	sql2008express();
#endif

	Result := true;
end;
