#SingleInstance Force
#Requires AutoHotkey v2
global AppName := "HACK: Hekili Automation and Control Kit"
#Include speedbuilder\class\Config.ahk
#Include speedbuilder\class\Profile.ahk
#Include speedbuilder\class\Git.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\includes\Helpers.ahk
#Include speedbuilder\gui\TrayMenu.ahk
#Include speedbuilder\gui\Main.ahk
#Include speedbuilder\gui\ProfileSetup.ahk
#Include speedbuilder\gui\HekiliSetup.ahk
#Include speedbuilder\gui\KeybindList.ahk
CoordMode('ToolTip', 'Screen')
TraySetIcon("speedbuilder\resources\hack.ico")
global cfg := Config()
global ActiveProfile := ""

; Check for updates before anything
Updater := Git()
if Updater.Ready
    Updater.Update()

if !cfg.Exists() {
    if MsgBox("Config file not yet created.`n`nWould you like to run first time setup now?", AppName, "0x34") = "Yes" {
        cfg.Save()
        HekiliSetupGui()
    } else
        ExitApp()
} else {
    cfg := cfg.Load()

    ; Check if profiles are setup
    Profiles := GetProfileNames()
    if !Profiles.Length {
        if MsgBox("No profiles have been setup.`n`nWould you like to setup a profile now?", AppName, "0x34") = "Yes" {
            ProfileSetupGui()
        } else {
            ExitApp()
        }
    } else {
        ; Open main window on startup
        MainWindow()
    }
}

; Set hotkeys.
Hotkey(cfg.MainWindowKeybind, MainWindowHotkey)
HotIfWinActive(cfg.Warcraft)
Hotkey(cfg.ToggleKeyBind, ToggleSpeedBuilder)
HotIfWinActive()

ToggleSpeedBuilder(PressedHotKey) {
    if !ActiveProfile
        return

    cfg.ToggleState := !cfg.ToggleState
    SetTimer Rotation, cfg.ToggleState ? cfg.TickRate : 0

    showPopup(ActiveProfile.Name " rotation " (cfg.ToggleState ? "activated." : "deactivated."))
}

MainWindowHotkey(PressedHotKey) => MainGui.Show()

Rotation() {
    if !WinActive(cfg.Warcraft) {
        return
    }

    try {
        colors := GetPixelColors()
        action := ActiveProfile.Actions[colors]
        
        if action
            action.Use()
    }
}
