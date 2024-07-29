; Safety escape
Escape::ExitApp()

global AppName := "SpeedBuilder Class Setup"
if !FileExist("config.ini") {
    Result := MsgBox("Config file not yet created.`n`nWould you like to run first time setup now?", AppName, "0x34")
    if Result = "Yes" {
        Run("ConfigSetup.ahk")
    }
    ExitApp()
}

#Include speedbuilder\includes\ConfigManager.ahk
#Include speedbuilder\gui\SpecSelectSetup.ahk

global Config := LoadConfig()

; Stop if warcraft isnt running.
if !WinExist(Config.Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName)
    ExitApp()
}

; Start class spec selection.
SpecSetupSelection()
