#SingleInstance Force

AppName := "Run"
if !FileExist("config.ini") {
    MsgBox("Config file not created, please run ConfigSetup.ahk.", AppName)
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

; Change this to change te button to toggle the rotation on and off.
ToggleSpeedBuilder(PressedHotKey) {
    global Toggle
    global Keybinds

    SetTimer Rotation, (Toggle := !Toggle) ? TickRate : 0

    if Toggle {
        TrayTip(AppName, "Rotation activated.")
    } else {
        TrayTip(AppName, "Rotation deactivated.")
    }
}

SpecSelectionHotkey(PressedHotKey) {
    SpecSelection(Config)
}

Rotation() {
    if WinActive(Config.Warcraft) {
        try {
            colors := GetPixelColors()
    
            if Keybinds[colors] {
                Send(Keybinds[colors].Keybind)
            }
        }
    }
}