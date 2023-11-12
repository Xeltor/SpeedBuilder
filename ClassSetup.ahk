; Safety escape
Escape::ExitApp()

global AppName := "Class Setup"
#Include speedbuilder\includes\Globals.ahk
#Include speedbuilder\gui\SpecSelectSetup.ahk

if !FileExist("config.ini") {
    MsgBox("Config file not created, please run ConfigSetup.ahk.", AppName)
    ExitApp()
}

; Start class spec selection.
SpecSetupSelection()
