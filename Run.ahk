#SingleInstance Force
#Requires AutoHotkey v2
CoordMode('ToolTip', 'Screen')

AppName := "HACK: Hekili Automation and Control Kit"
if !FileExist("config.ini") {
    Result := MsgBox("Config file not yet created.`n`nWould you like to run first time setup now?", AppName, "0x34")
    if Result = "Yes" {
        Run("speedbuilder\setup\ConfigSetup.ahk")
    }
    ExitApp()
}

#Include speedbuilder\class\Config.ahk
#Include speedbuilder\includes\SpellBook.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\gui\SpecSelection.ahk
#Include speedbuilder\gui\SpecSelectSetup.ahk

global Toggle := false
global TickRate := 1000 / 60
global SelectedClassSpec := ""
global Keybinds := ""

; Load config.
global cfg := Config.LoadConfigFile()

; Set hotkeys.
; HotIfWinActive(cfg.Warcraft)
Hotkey(cfg.ToggleOnOffKeyBind, ToggleSpeedBuilder)
Hotkey(cfg.SpecSelectionKeyBind, SpecSelectionHotkey)
; HotIfWinActive()

; Check if class specs are setup.
if !FileExist("Keybinds\*.txt") {
    Result := MsgBox("No class specs have been setup.`n`nWould you like to setup a class spec now?", AppName, "0x34")
    if Result = "Yes" {
        SpecSetupSelection()
    } else {
        ExitApp()
    }
} else {
    ; Select spec gui on startup.
    SpecSelection()
}


ToggleSpeedBuilder(PressedHotKey) {
    global Toggle
    global Keybinds

    if !cfg.CurrentSpec
        return

    ClassSpec := cfg.GetFormattedCurrentSpec()

    SetTimer Rotation, (Toggle := !Toggle) ? TickRate : 0

    if Toggle {
        showPopup(ClassSpec " rotation activated.")
    } else {
        showPopup(ClassSpec " rotation deactivated.")
    }
}

SpecSelectionHotkey(PressedHotKey) {
    SpecSelection()
}

showPopup(Message) {
    x := A_ScreenWidth - ( 5 * StrLen(Message) )
    y := A_ScreenHeight

    ToolTip("`n" Message "`n ", x, y)
    ; Hide the tooltip after 3 seconds
    SetTimer(() => ToolTip(""), -5000)
}

Rotation() {
    if WinActive(cfg.Warcraft) {
        try {
            colors := GetPixelColors()
    
            if Keybinds[colors] {
                ; Check if alias.
                if (SubStr(Keybinds[colors].Keybind, 1, 1) = cfg.AliasPrefix) {
                    ReplacementBind := FindAlias(Keybinds[colors].Keybind, Keybinds)
                    if (ReplacementBind) {
                        Send(ReplacementBind)
                    }

                ; No alias
                } else {
                    Send(Keybinds[colors].Keybind)
                }
            }
        }
    }
}

FindAlias(name, binds) {
    name := Trim(StrReplace(name, Config.AliasPrefix, ""))

    for key, obj in binds {
        if (StrLower(obj.Name) = StrLower(name)) {
            return obj.Keybind
        }
    }
    return false
}