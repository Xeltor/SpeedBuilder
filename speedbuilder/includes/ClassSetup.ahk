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
    KeybindFile := SetClassKeybinds(SetupData.ClassSpecChoice.FileName, ActionList)

    ; Notify user that the process has completed.
    Result := MsgBox("The automatic process has completed.`n`nDo you want to open the keybind file to setup/update your keybinds?", AppName, "0x44")
    if Result = "Yes" {
        Run("explorer.exe " KeybindFile, A_WorkingDir)
    }
    
    if !FileExist("Keybinds\*.txt")
        ExitApp()
    else
        SpecSelection()
}

SetClassKeybinds(ClassSpec, Keybinds) {
    if !DirExist("Keybinds"){
        DirCreate("Keybinds")
    }

    KeybindFile := "Keybinds\" ClassSpec ".txt"
    BackupFile := "Keybinds\" ClassSpec "_backup.txt"
    if FileExist(KeybindFile){
        FileMove(KeybindFile, BackupFile)
    }

    Header := [
        "-- " ClassSpec " keybind file.",
        "-- ",
        "-- Add keybinds at the end of each line using the below format, you can skip spells that are not used.",
        "-- ",
        "-- Alphabetical: a - z ",
        "-- Numeric: 0 - 9",
        "-- F-keys: {F1} - {F24}",
        "-- Numpad: {Numpad0} - {Numpad9}",
        "-- Control(CTRL): ^",
        "-- Shift: +",
        "-- Alt: !",
        "-- ",
        "-- Example1: Control + Shift + F10 = ^+{F10}",
        "-- Example2: Control + Alt + 1 = ^!1"
    ]

    Footer := [
        "`n-- Keybind aliases. Do not change.`n"
    ]

    ; Write Header.
    for line in Header {
        FileAppend(line "`n", KeybindFile)
    }

    ; Write keybinds.
    FileAppend("`n-- Class spells and talents.`n", KeybindFile)
    for Name, Spell in Keybinds {
        if Spell.ActionType = "Spell" {
            SpellLine := Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n"
            if Spell.IsAlias
                Footer.Push(SpellLine)
            else
                FileAppend(SpellLine, KeybindFile)
        }
    }

    FileAppend("`n-- Racial spells.`n", KeybindFile)
    for Name, Spell in Keybinds {
        if Spell.ActionType = "Common" {
            SpellLine := Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n"
            if Spell.IsAlias
                Footer.Push(SpellLine)
            else
                FileAppend(SpellLine, KeybindFile)
        }
    }

    FileAppend("`n-- Items.`n", KeybindFile)
    for Name, Spell in Keybinds {
        if Spell.ActionType = "Item" {
            SpellLine := Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n"
            if Spell.IsAlias
                Footer.Push(SpellLine)
            else
                FileAppend(SpellLine, KeybindFile)
        }
    }

    ; Write footer.
    if Footer.Length > 1 {
        for line in Footer {
            FileAppend(line, KeybindFile)
        }
    }

    ; Remove backup.
    if FileExist(BackupFile) {
        FileDelete(BackupFile)
    }

    return KeybindFile
}