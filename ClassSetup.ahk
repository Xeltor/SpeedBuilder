; Safety escape
Escape::ExitApp()

global AppName := "Class Setup"
#Include speedbuilder\includes\ConfigManager.ahk
#Include speedbuilder\gui\SpecSelectSetup.ahk

global Config := LoadConfig()

; Stop if warcraft isnt running.
if !WinExist(Config.Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName)
    ExitApp()
}

if !FileExist("config.ini") {
    MsgBox("Config file not created, please run ConfigSetup.ahk.", AppName)
    ExitApp()
}

; Start class spec selection.
SpecSetupSelection()
