#SingleInstance Force
#Requires AutoHotkey v2
#Include speedbuilder\class\Config.ahk
#Include speedbuilder\class\Specialization.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\gui\SpecSelection.ahk
#Include speedbuilder\gui\SpecSelectSetup.ahk
CoordMode('ToolTip', 'Screen')
global AppName := "HACK: Hekili Automation and Control Kit"
global cfg := Config()
global LoadedSpec := ""

if !cfg.ConfigFileExists() {
    Result := MsgBox("Config file not yet created.`n`nWould you like to run first time setup now?", AppName, "0x34")
    if Result = "Yes" {
        Run("speedbuilder\setup\ConfigSetup.ahk")
    }
    ExitApp()
} else {
    cfg := cfg.LoadConfigFile()
}

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

; Set hotkeys.
HotIfWinActive(cfg.Warcraft)
Hotkey(cfg.ToggleOnOffKeyBind, ToggleSpeedBuilder)
Hotkey(cfg.SpecSelectionKeyBind, SpecSelectionHotkey)
HotIfWinActive()

ToggleSpeedBuilder(PressedHotKey) {
    if !LoadedSpec
        return

    ClassSpec := LoadedSpec.Name

    SetTimer Rotation, (cfg.ToggleState := !cfg.ToggleState) ? cfg.TickRate : 0

    if cfg.ToggleState {
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
    
            if LoadedSpec.Actions[colors] {
                ; Check if alias.
                if LoadedSpec.Actions[colors].IsAlias {
                    ReplacementBind := LoadedSpec.GetAlias(LoadedSpec.Actions[colors].Name)
                    if (ReplacementBind) {
                        Send(ReplacementBind)
                    }

                ; No alias
                } else {
                    Send(LoadedSpec.Actions[colors].Keybind)
                }
            }
        }
    }
}
