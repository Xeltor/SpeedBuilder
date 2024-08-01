#Include ColorPicker.ahk

AutomaticClassSetup(SetupData, RedoAllIcons) {
    ; Update actions from definitions.
    ActionList := []
    for Definition in SetupData.ClassSpecChoice.Definitions {
        ; Update existing
        if SetupData.ClassSpecChoice.Actions.Has(Definition.Name) {
            NewAction := SetupData.ClassSpecChoice.Actions[Definition.Name].FromDefinition(Definition)
        } else {
            NewAction := Action().FromDefinition(Definition)
        }

        ActionList.Push(NewAction)
    }

    ; Get color combo for each icon.
    TotalItems := ActionList.Length
    i := 1
    for Act in ActionList {
        if Act.IsUpdated or RedoAllIcons {
            showPopup("Progress: " i "/" TotalItems)
            SetIconReplacement(Act.IconID, SetupData.xCoord, SetupData.yCoord)
            Act.Colors := GetPixelColors(true)
        }
        i++
    }
    ResetIconReplacement(SetupData.xCoord, SetupData.yCoord)

    ; Write to keybinds file.
    KeybindFile := SetClassKeybinds(SetupData.ClassSpecChoice, ActionList)

    ; Notify user that the process has completed.
    if FileExist(KeybindFile) {
        if MsgBox("The automatic process has completed.`n`nDo you want to open the keybind file to setup/update your keybinds?", AppName, "0x44") = "Yes" {
            Run("explorer.exe " KeybindFile, A_WorkingDir)
        }
    }
    
    ; Return to main menu on completion.
    SpecSelectionGui()
}

SetClassKeybinds(ClassSpec, Keybinds) {
    KeybindDir := "Keybinds"
    if !DirExist(KeybindDir) {
        DirCreate(KeybindDir)
    }

    KeybindFile := KeybindDir "\" ClassSpec.FileName ".txt"
    BackupFile := KeybindDir "\" ClassSpec.FileName "_backup.txt"

    ; Backup existing file
    if FileExist(KeybindFile) {
        FileMove(KeybindFile, BackupFile, true)
    }

    try {
        ; Write header
        Header := [
            "-- " ClassSpec.Name " keybind file.`n",
            "-- `n",
            "-- Add keybinds at the end of each line using the below format, you can skip spells that are not used.`n",
            "-- `n",
            "-- Alphabetical: a - z `n",
            "-- Numeric: 0 - 9`n",
            "-- F-keys: {F1} - {F24}`n",
            "-- Numpad: {Numpad0} - {Numpad9}`n",
            "-- Control(CTRL): ^`n",
            "-- Shift: +`n",
            "-- Alt: !`n",
            "-- `n",
            "-- Example1: Control + Shift + F10 = ^+{F10}`n",
            "-- Example2: Control + Alt + 1 = ^!1`n"
        ]
    
        ; Keybind aliases
        Aliases := [
            "`n-- Keybind aliases. Do not change.`n"
        ]
    
        ; Write header
        WriteSection(KeybindFile, Header)
    
        ; Process and append keybinds
        Aliases := WriteKeybinds(KeybindFile, Keybinds, "Spell", Aliases)
        Aliases := WriteKeybinds(KeybindFile, Keybinds, "Common", Aliases)
        Aliases := WriteKeybinds(KeybindFile, Keybinds, "Item", Aliases)
    
        ; Write footer if there are any aliases
        if Aliases.Length > 1
            WriteSection(KeybindFile, Aliases)
    } catch as e {
        ErrorMessage := "Failed to create Keybinds file"

        ; Restore backup file if it exists
        if FileExist(BackupFile) {
            FileMove(BackupFile, KeybindFile, true)
            ErrorMessage .= ", original file has been recovered."
        } else {
            ErrorMessage .= "."
        }

        ; Display error message
        MsgBox(ErrorMessage "`n`nError message: " e.Message, AppName, "0x10")
    } else {
        ; Remove backup
        if FileExist(backupFile) {
            FileDelete(backupFile)
        }
    }

    return keybindFile
}

WriteSection(keybindFile, lines) {
    for line in lines {
        FileAppend(line, keybindFile)
    }
}

WriteKeybinds(keybindFile, keybinds, actionType, aliases) {
    FileAppend("`n-- " actionType " spells.`n", keybindFile)

    for _, spell in keybinds {
        if (spell.ActionType = actionType) {
            spellLine := spell.Name "," spell.IconID "," spell.Colors "," spell.Keybind "`n"
            if (spell.IsAlias) {
                aliases.Push(spellLine)
            } else {
                FileAppend(spellLine, keybindFile)
            }
        }
    }

    return aliases
}
