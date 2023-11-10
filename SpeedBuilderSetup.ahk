; Safety escape
Escape::ExitApp()

; Setup globals
global TargetGui := ""
global SupportGui := ""
global AppName := "Speed Builder Setup"
#Include includes\Globals.ahk

; Setup base ini config if it doesnt exist.
if !FileExist("config.ini"){
    IniWrite("100", "config.ini", "Hekili", "xCoord")
    IniWrite("100", "config.ini", "Hekili", "yCoord")
    IniWrite("50", "config.ini", "Hekili", "BoxWidth")
}

#include gui\Support.ahk
#include gui\Target.ahk

; Draw GUI.
TargetGui := DrawTargetGui(Hekili)
SupportGui := DrawSupportGui()

; Activate WoW.
WinActivate(Warcraft)