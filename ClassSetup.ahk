; Safety escape
Escape::ExitApp()

#Include includes\Globals.ahk
#Include includes\SpellBook.ahk
global AppName := "Class Setup"

if !FileExist("config.ini") {
    MsgBox("Config file not created, please run SpeedBuilderSetup.", AppName)
    ExitApp()
}

Spellbooks := GetSpellbooks()

; TODO: The whole damned thing.