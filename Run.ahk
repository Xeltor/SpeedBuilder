#SingleInstance Force
#Requires AutoHotkey v2
#Include speedbuilder\class\Config.ahk
#Include speedbuilder\class\Specialization.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\includes\Helpers.ahk
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
if !GetClassSpecs().Length {
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

    SetTimer Rotation, (cfg.ToggleState := !cfg.ToggleState) ? cfg.TickRate : 0

    if cfg.ToggleState {
        showPopup(LoadedSpec.Name " rotation activated.")
    } else {
        showPopup(LoadedSpec.Name " rotation deactivated.")
    }
}

SpecSelectionHotkey(PressedHotKey) => SpecSelection()

Rotation() {
    if !WinActive(cfg.Warcraft) {
        return
    }

    try {
        colors := GetPixelColors()
        action := LoadedSpec.Actions[colors]
        
        if action {
            keybind := action.IsAlias ? LoadedSpec.GetActionByAlias(action.Keybind) : action.Keybind
            if keybind {
                Send(keybind)
            }
        }
    }
}
