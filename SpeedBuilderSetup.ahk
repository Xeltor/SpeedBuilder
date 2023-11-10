; Safety escape
Escape::ExitApp()

; Setup globals
global TargetGui := ""
global SupportGui := ""
global BoxWidth := IniRead("config.ini", "Hekili", "BoxWidth", "50")
global xCoord := IniRead("config.ini", "Hekili", "xCoord", "100")
global yCoord := IniRead("config.ini", "Hekili", "yCoord", "100")
global AppName := "Speed Builder Setup"
global Warcraft := "" ; TODO: Get from game client.

; Stop if warcraft isnt running.
if !WinExist(Warcraft) {
    MsgBox("Please make sure World of Warcraft is running and Hekili's main box is visible.`nThen run this application again.", AppName)
    ExitApp()
}

; Setup base ini config if it doesnt exist.
if !FileExist("config.ini"){
    IniWrite("100", "config.ini", "Hekili", "xCoord")
    IniWrite("100", "config.ini", "Hekili", "yCoord")
    IniWrite("50", "config.ini", "Hekili", "BoxWidth")
}

#include includes/SupportGui.ahk
#include includes/TargetGUI.ahk

; Activate warcraft to draw the GUI.
WinActive(Warcraft)
WinWaitActive(Warcraft)

; Draw GUI.
TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth)
SupportGui := DrawSupportGui()