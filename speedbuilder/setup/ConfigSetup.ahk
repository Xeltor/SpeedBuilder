#Requires AutoHotkey v2
#Include ..\class\Config.ahk
global AppName := "SLASH: System Layout And Settings Handler"
global cfg := Config()

; Safety escape
Escape::{
    if cfg {
        cfg.SaveConfigFile(true)
    }
    if cfg.ConfigFileExists(true) {
        Run("..\..\Run.ahk")
    }
    ExitApp()
}

; Setup globals
global TargetGui := ""
global SupportGui := ""

if cfg.ConfigFileExists(true) {
    cfg.LoadConfigFile(true)
}

; Stop if warcraft isnt running.
if !WinExist(cfg.Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName, "0x30")
    if cfg.ConfigFileExists(true) {
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