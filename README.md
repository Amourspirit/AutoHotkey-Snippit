#AutoHotkey Snippit
AutoHotkey Snippit is a Program designed with the intention of having multiple types of Hotkeys, HotStrings and Include Plugins for use in windows Automation.

##Installing AutoHotkey Snipit
AutoHotkey Snippit can be installed via the [AutoHotkeySnippitSetup.exe][1] installer.
###Reqirements
AutoHotkey Snippit requires .net framework, [AutoHotKey][3] and [Mini-Framework][4].  All of the requriements are automatically installed by the [AutoHotkeySnippitSetup.exe][1] installer as needed.

####Getting Help
Help can be founnd online [here][2] as well AutoHotkey Snippit has a help file wihen it is installed.

###Sharing Snippits
AutoHotkey Snippit is designed with sharing of snippetsin mind. Snippets can be exported and import via the Hotlist Application.

####Getting Started
Having a basic understanding of [AutoHotKey][3] is helpful but not necessary to get started. **AutoHotkey Snippit** comes with a few templates already installed. The Default profile when installed is *Windows Global.* Which include shortcuts to many of windows control panel items.  
As well there is an auto correct plugin included with the *Windows Global* that auto corrects hundreds of spelling mistakes.

The **AutoHotkey Snippit** application is the main launch point for the program and runs in the system tray. If the **AutoHotkey Snipit** is not running in the system tray then no Hotkeys, Hotstring plugins willl be active. Althouth you may stil edit any profiles or plugin using the **Hotlist** application.

**Plugins may contain three flavors.**

* Hotkeys - These are Actions that are taken when a specified hot key is pressed such as Ctrl+Win+A , 
* HotStrings - These are the Actions taken when a keyboard sequence is pressed such as sayhello and are often use to create text replacements for such things as auto correct.
* Includes - These are custom Actions that can be anything supported by the AutoHotkey Scripting language including custom Hotkeys and HotStrings. Includes are more powerful but more difficult then working with Hotkeys and HotStrings. Most if not all of your need Hotkeys and HotStrings will probably do the job. 

**Some Features of AutoHotkey Snippit**

* Create a Global Profile - Profile will act on all windows except the window specifically blacklisted. 
* Create a Local Profile - Profile will act on only the windows in the white list. 
* Import / Export Snippit Install as shown in figure 1 
* Import / Export Plugin into Profiles as shown in figure 2 
* Create one or more Individual Plugins - Plugins can be created within Profiles as demonstrated by figure 1. 
* Plugins may be optionally disabled within a Profile - Great for plugins within a Profile that you only use occasionally. 
* Plugins may be deleted 
* Plugins may be copied to another Profile 
* Plugins may be Moved to another Profile 
* Plugins may disable Hotkeys, HotStrings and Includes individually. 
* Data may be part of a plugin to enhance is capability. 
* Data can be included as Text or Binary 

___
Note to Developers:  
AutoHotkey Snippit plugin and profiles are based up xml files. This files are included in the **XSD** folder for developer if needed. The documentation for the xsd files can be found online [here][5]

Having knowledge of or using he xsd/xml files is not required in any way. The Hotlist application will do all of this automatically when you create or edit a new Profile or plugin. However if a developer needs access to them they are provided.

[1]:https://github.com/Amourspirit/AutoHotkey-Snippit/raw/master/Bin/Stable/Latest/AutoHotkeySnippitSetup.exe
[2]:https://amourspirit.github.io/AutoHotkey-Snippit
[3]:https://autohotkey.com
[4]:https://github.com/Amourspirit/Mini-Framework
[5]:https://amourspirit.github.io/AutoHotkey-Snippit/xsd_docs/