#Include SpellBook.ahk
#Include ColorPicker.ahk

AutomaticClassSetup(SetupData) {
    Spellbook := Map()

    ; Get class spec data.
    Spellbook := GetClassSpells(SetupData.ClassSpecChoice, Spellbook)

    ; Add common spells.
    Spellbook := GetCommonSpells(Spellbook)

    ; Add common items.
    Spellbook := GetCommonItems(Spellbook)

    ; Get existing player keybinds if exist.
    Spellbook := GetClassKeybinds(SetupData.ClassSpecChoice, Spellbook, true)

    ; Get color combo for each icon.
    for IconID, Spell in Spellbook {
        SetIconReplacement(Spell.IconID, SetupData.xCoord, SetupData.yCoord)
        Spell.Colors := GetPixelColors(true)
    }
    ResetIconReplacement(SetupData.xCoord, SetupData.yCoord)

    ; Write to keybinds file.
    SetClassKeybinds(SetupData.ClassSpecChoice, Spellbook)

    ; Notify user that the process has completed.
    MsgBox("The automatic process has completed, you can now open the Keybinds folder and setup/update your keybinds.", AppName)
    ExitApp()
}