; Safety escape
Escape::ExitApp()

; Setup globals
global TargetGui := ""
global SupportGui := ""
global AppName := "Speed Builder Setup"
#Include speedbuilder\includes\Globals.ahk

; Stop if warcraft isnt running.
if !WinExist(Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName)
    ExitApp()
}

; Setup base ini config if it doesnt exist.
if !FileExist("config.ini"){
    IniWrite("100", "config.ini", "Hekili", "xCoord")
    IniWrite("100", "config.ini", "Hekili", "yCoord")
    IniWrite("50", "config.ini", "Hekili", "BoxWidth")
}

#include speedbuilder\gui\Support.ahk
#include speedbuilder\gui\Target.ahk

; Draw GUI.
TargetGui := DrawTargetGui(Hekili)
SupportGui := DrawSupportGui()

; Activate WoW.
WinActivate(Warcraft)