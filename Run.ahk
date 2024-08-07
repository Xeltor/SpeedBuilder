#SingleInstance Force
#Requires AutoHotkey v2
#Include speedbuilder\class\Config.ahk
#Include speedbuilder\class\Specialization.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\includes\Helpers.ahk
#Include speedbuilder\gui\SpecSelection.ahk
#Include speedbuilder\gui\SpecSelectSetup.ahk
#Include speedbuilder\gui\KeybindListGui.ahk
CoordMode('ToolTip', 'Screen')
global AppName := "HACK: Hekili Automation and Control Kit"
global cfg := Config()
global LoadedSpec := ""

if !cfg.ConfigFileExists() {
    if MsgBox("Config file not yet created.`n`nWould you like to run first time setup now?", AppName, "0x34") = "Yes" {
        Run("speedbuilder\setup\ConfigSetup.ahk")
    }
    ExitApp()
} else {
    cfg := cfg.LoadConfigFile()
}

; Check if class specs are setup
classSpecs := GetClassSpecs()
if !classSpecs.Length {
    if MsgBox("No class specs have been setup.`n`nWould you like to setup a class spec now?", AppName, "0x34") = "Yes" {
        SpecSetupSelectionGui()
    } else {
        ExitApp()
    }
} else {
    ; Select spec GUI on startup
    SpecSelectionGui()
}

; Set hotkeys.
HotIfWinActive(cfg.Warcraft)
Hotkey(cfg.ToggleOnOffKeyBind, ToggleSpeedBuilder)
Hotkey(cfg.SpecSelectionKeyBind, SpecSelectionHotkey)
HotIfWinActive()

ToggleSpeedBuilder(PressedHotKey) {
    if !LoadedSpec
        return

    cfg.ToggleState := !cfg.ToggleState
    SetTimer Rotation, cfg.ToggleState ? cfg.TickRate : 0

    showPopup(LoadedSpec.Name " rotation " (cfg.ToggleState ? "activated." : "deactivated."))
}

SpecSelectionHotkey(PressedHotKey) => SpecSelectionGui()

Rotation() {
    if !WinActive(cfg.Warcraft) {
        return
    }

    try {
        colors := GetPixelColors()
        action := LoadedSpec.Actions[colors]
        
        if action {
            keybind := action.IsAlias ? LoadedSpec.GetActionByAlias(action.Keybind) : action.Keybind
            if keybind != "" {
                Send(keybind)
            }
        }
    }
}
