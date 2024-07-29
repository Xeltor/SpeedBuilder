#SingleInstance Force
#Requires AutoHotkey v2
CoordMode('ToolTip', 'Screen')

AppName := "SpeedBuilder"
if !FileExist("config.ini") {
    Result := MsgBox("Config file not yet created.`n`nWould you like to run first time setup now?", AppName, "0x34")
    if Result = "Yes" {
        Run("ConfigSetup.ahk")
    }
    ExitApp()
}

#Include speedbuilder\includes\ConfigManager.ahk
#Include speedbuilder\includes\SpellBook.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\gui\SpecSelection.ahk

global Toggle := false
global TickRate := 1000 / 60
global SelectedClassSpec := ""
global Keybinds := ""

; Load config.
global Config := LoadConfig()

; Set hotkeys.
Hotkey(Config.ToggleOnOffKeyBind, ToggleSpeedBuilder)
Hotkey(Config.SpecSelectionKeyBind, SpecSelectionHotkey)

; Select spec gui on startup.
SpecSelection(Config)

ToggleSpeedBuilder(PressedHotKey) {
    global Toggle
    global Keybinds

    SetTimer Rotation, (Toggle := !Toggle) ? TickRate : 0

    if Toggle {
        showPopup("Rotation activated.", 112)
    } else {
        showPopup("Rotation deactivated.", 125)
    }
}

SpecSelectionHotkey(PressedHotKey) {
    SpecSelection(Config)
}

showPopup(Message, Width) {
    x := A_ScreenWidth - Width
    y := A_ScreenHeight - 50

    ToolTip("`n" Message "`n ", x, y)
    ; Hide the tooltip after 3 seconds
    SetTimer(() => ToolTip(""), -3000)
}

Rotation() {
    if WinActive(Config.Warcraft) {
        try {
            colors := GetPixelColors()
    
            if Keybinds[colors] {
                ; Replacement 
                if (SubStr(Keybinds[colors].Keybind, 1, 1) = Config.AliasPrefix) {
                    ReplacementBind := FindReplacementBind(Keybinds[colors].Keybind, Keybinds)
                    if (ReplacementBind) {
                        Send(ReplacementBind)
                    }
                } else {
                    Send(Keybinds[colors].Keybind)
                }
            }
        }
    }
}

FindReplacementBind(name, binds) {
    name := Trim(StrReplace(name, Config.AliasPrefix, ""))

    for key, obj in binds {
        if (StrLower(obj.Name) = StrLower(name)) {
            return obj.Keybind
        }
    }
    return false
}