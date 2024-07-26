#Include SpellBook.ahk
#Include ColorPicker.ahk

AutomaticClassSetup(SetupData, RedoAllIcons) {
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
        if Spell.Updated or RedoAllIcons {
            SetIconReplacement(Spell.IconID, SetupData.xCoord, SetupData.yCoord)
            Spell.Colors := GetPixelColors(true)
        }
    }
    ResetIconReplacement(SetupData.xCoord, SetupData.yCoord)

    ; Write to keybinds file.
    KeybindFile := SetClassKeybinds(SetupData.ClassSpecChoice, Spellbook)

    ; Notify user that the process has completed.
    Result := MsgBox("The automatic process has completed.`n`nDo you want to open the keybind file to setup/update your keybinds?", AppName, "0x44")
    if Result = "Yes" {
        Run("explorer.exe " KeybindFile, A_WorkingDir)
    }

    ExitApp()
}