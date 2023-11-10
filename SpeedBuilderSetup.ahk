; Setup base ini config.
if !FileExist("config.ini"){
    IniWrite("100", "config.ini", "Hekili", "xCoord")
    IniWrite("100", "config.ini", "Hekili", "yCoord")
    IniWrite("50", "config.ini", "Hekili", "BoxWidth")
}

; Setup globals
global TargetGui := ""
global SupportGui := ""
global BoxWidth := IniRead("config.ini", "Hekili", "BoxWidth", "50")
global xCoord := IniRead("config.ini", "Hekili", "xCoord", "100")
global yCoord := IniRead("config.ini", "Hekili", "yCoord", "100")
global AppName := "Speed Builder Setup"

#include includes/SupportGui.ahk
#include includes/TargetGUI.ahk

; Safety escape
Escape:: {
    global TargetGui

    if (TargetGui != "") {
        TargetGui.Destroy()
        TargetGui := ""
    }

    ; We done here.
    ExitApp()
}

TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth)
SupportGui := DrawSupportGui()