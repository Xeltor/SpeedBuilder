#Requires AutoHotkey v2
global AppName := "SpeedBuilder Setup"

; Safety escape
Escape::{
    if FileExist("..\config.ini") {
        Result := MsgBox("Config file has been created.`n`nStart SpeedBuilder?", AppName, "0x24")
        if Result = "Yes" {
            Run("..\Run.ahk")
        }
    }
    ExitApp()
}

; Setup globals
global TargetGui := ""
global SupportGui := ""
#Include ..\includes\ConfigManager.ahk

; Load config.
global Config := LoadConfig("..\")

; Stop if warcraft isnt running.
if !WinExist(Config.Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName)
    ExitApp()
}

#include gui\Support.ahk
#include gui\Target.ahk

; Draw GUI.
TargetGui := DrawTargetGui(Config.Hekili)
SupportGui := DrawSupportGui()

; Activate WoW.
WinActivate(Config.Warcraft)