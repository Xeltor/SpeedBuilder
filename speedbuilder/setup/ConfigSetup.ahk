#Requires AutoHotkey v2
global AppName := "SLASH: System Layout And Settings Handler"

; Safety escape
Escape::{
    if cfg {
        cfg.SaveConfigFile("..\..\")
    }
    if FileExist("..\..\config.ini") {
        Run("..\..\Run.ahk")
    }
    ExitApp()
}

; Setup globals
global TargetGui := ""
global SupportGui := ""
#Include ..\class\Config.ahk

; Global config.
global cfg := {}

if FileExist("..\..\config.ini") {
    cfg := Config.LoadConfig("..\..\")
} else {
    cfg := Config.New()
}

; Stop if warcraft isnt running.
if !WinExist(cfg.Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName, "0x30")
    if FileExist("..\..\config.ini") {
        Run("..\..\Run.ahk")
    }
    ExitApp()
}

#include gui\Support.ahk
#include gui\Target.ahk

; Draw GUI.
TargetGui := DrawTargetGui()
SupportGui := DrawSupportGui()

; Activate WoW.
WinActivate(cfg.Warcraft)