; Safety escape
Escape::ExitApp()

; Setup globals
global TargetGui := ""
global SupportGui := ""
global AppName := "Speed Builder Setup"
#Include speedbuilder\includes\ConfigManager.ahk

; Load config.
global Config := LoadConfig()

; Stop if warcraft isnt running.
if !WinExist(Config.Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName)
    ExitApp()
}

#include speedbuilder\gui\Support.ahk
#include speedbuilder\gui\Target.ahk

; Draw GUI.
TargetGui := DrawTargetGui(Config.Hekili)
SupportGui := DrawSupportGui()

; Activate WoW.
WinActivate(Config.Warcraft)