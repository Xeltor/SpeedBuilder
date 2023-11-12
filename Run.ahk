#SingleInstance Force

AppName := "Run"
if !FileExist("config.ini") {
    MsgBox("Config file not created, please run SpeedBuilderSetup.", AppName)
    ExitApp()
}

#Include speedbuilder\includes\Globals.ahk
#Include speedbuilder\includes\SpellBook.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\gui\SpecSelection.ahk

global Toggle := false
global TickRate := 1000 / 60
global SelectedClassSpec := ""
global Keybinds := ""

; Select spec gui on startup.
SpecSelection()

; Change this to change te button to toggle the rotation on and off.
`:: {
    global Toggle
    global Keybinds

    SetTimer Rotation, (Toggle := !Toggle) ? TickRate : 0

    if Toggle {
        TrayTip(AppName, "Rotation activated.")
    } else {
        TrayTip(AppName, "Rotation deactivated.")
    }
}

#HotIf WinActive(Warcraft)
#F12:: {
    SpecSelection()
}
#HotIf

Rotation() {
    if WinActive(Warcraft) {
        try {
            colors := GetPixelColors()
    
            if Keybinds[colors] {
                Send(Keybinds[colors].Keybind)
            }
        }
    }
}