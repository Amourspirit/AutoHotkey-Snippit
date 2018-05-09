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


class AhkHotkeys extends MfObject
{
    
    __New(args*)
    {
        base.__New()
        ; Throws MfNotSupportedException if AhkHotkeys Sealed class is extended
        if (this.__Class != "AhkHotkeys") {
            throw new MfNotSupportedException(MfEnvironment.Instance.GetResourceString("NotSupportedException_Sealed_Class","AhkHotkeys"))
        }
        
    }
    
    static Win := "#" ; AutoHotkey Modifier Win
    static Shift := "+" ; AutoHotkey Modifier Shift
    static Alt := "!" ; AutoHotkey Modifier Alt
    static Ctrl := "^" ; AutoHotkey Modifier Ctrl
    static WildCard := "*" ; AutoHotkey Modifier Wildcard
    static Right := ">" ; AutoHotkey Modifier Right
    static Left := "<" ; AutoHotkey Modifier Left
    static Combine := "&" ;  AutoHotkey Key Combine Char
    static NativeBlock := "~" ; AutoHotkey Modifier Native Block
    static InstallHook := "$" ;AutoHotkey Install keyboard hook
    static Escape := "`" ; AutoHotkey Escape Char
    static CombineString := " & " ; AutoHotkey Install keyboard hook
    static UpString := " UP" ; AutoHotkey Modifier Combine Keys with correct spacing
    
    
    GetType()
    {
        return base.GetType()
    }
    
    Is(type)
    {
        typeName := null
        if (IsObject(type))
        {
            if (MfObject.IsObjInstance(type, "MfType"))
            {
                typeName := type.ClassName
            }
            else if (type.__Class)
            {
                typeName := type.__Class
            }
            else if (type.base.__Class)
            {
                typeName := type.base.__Class
            }
        }
        else if (type ~= "^[a-zA-Z0-9.]+$")
        {
            typeName := type
        }
        if (typeName = "AhkHotkeys")
        {
            return true
        }
        return base.Is(type)
    }
    
    IsObjInstance(obj, objType = "")
    {
        return MfObject.IsObjInstance(obj, objType)
    }
    
    ToString()
    {
        return base.ToString()
    }
    
}
