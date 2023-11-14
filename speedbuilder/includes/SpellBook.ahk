; Handles spec and keybind data.

GetClassSpecs(Setup := false) {
    ClassSpecs := []

    if Setup {
        DirLocation := "speedbuilder\definitions\*.txt"
    } else {
        DirLocation := "Keybinds\*.txt"
    }

    loop files DirLocation {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)

            ClassSpecs.Push(FileWithoutExt)
        }
    }

    return ClassSpecs
}

; Name, IconID
GetClassSpells(ClassSpec, Spellbook) {
    loop read, "speedbuilder\definitions\" ClassSpec ".txt" {
        if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
            continue
        }

        split := StrSplit(A_LoopReadLine, ',')

        if split.Length = 2 {
            Spell := Object()

            Spell.Name := Trim(split[1])
            Spell.IconID := Trim(split[2])
            Spell.Colors := ""
            Spell.Keybind := ""
            Spell.Updated := true
            Spell.Type := "Class"

            Spellbook[StrLower(Spell.Name)] := Spell
        }
    }

    return Spellbook
}

; Name, IconID
GetCommonItems(Items) {
    loop read, "speedbuilder\definitions\common_items.txt" {
        if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
            continue
        }

        split := StrSplit(A_LoopReadLine, ',')

        if split.Length = 2 {
            Item := Object()

            Item.Name := Trim(split[1])
            Item.IconID := Trim(split[2])
            Item.Colors := ""
            Item.Keybind := ""
            Item.Updated := true
            Item.Type := "Item"

            Items[StrLower(Item.Name)] := Item
        }
    }

    return Items
}

; Name, IconID
GetCommonSpells(Spellbook) {
    loop read, "speedbuilder\definitions\common_spells.txt" {
        if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
            continue
        }

        split := StrSplit(A_LoopReadLine, ',')

        if split.Length = 2 {
            Spell := Object()

            Spell.Name := Trim(split[1])
            Spell.IconID := Trim(split[2])
            Spell.Colors := ""
            Spell.Keybind := ""
            Spell.Updated := true
            Spell.Type := "Common"

            Spellbook[StrLower(Spell.Name)] := Spell
        }
    }

    return Spellbook
}

; Name, IconID, Colors, Keybind
GetClassKeybinds(ClassSpec, Spellbook, ByName := false) {
    if !FileExist("Keybinds\" ClassSpec ".txt")
        return Spellbook

    loop read, "Keybinds\" ClassSpec ".txt" {
        if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
            continue
        }

        split := StrSplit(A_LoopReadLine, ',')

        if split.Length = 4 {
            Spell := Object()

            Spell.Name := Trim(split[1])
            Spell.IconID := Trim(split[2])
            Spell.Colors := Trim(split[3])
            Spell.Keybind := Trim(split[4])

            if ByName {
                ; Remove spells no longer in the definition.
                try {
                    if Spellbook[StrLower(Spell.Name)] {
                        ; Check if the IconID is different from the keybind file.
                        if Spellbook[StrLower(Spell.Name)].IconID != Spell.IconID {
                            Spellbook[StrLower(Spell.Name)].Updated := true
                        } else {
                            Spellbook[StrLower(Spell.Name)].Updated := false
                        }

                        Spellbook[StrLower(Spell.Name)].Colors := Spell.Colors
                        Spellbook[StrLower(Spell.Name)].Keybind := Spell.Keybind
                    }
                }
            } else {
                Spellbook[Spell.Colors] := Spell
            }
        }
    }

    return Spellbook
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

    Explanation := [
        "-- " ClassSpec " keybind file.",
        "-- ",
        "-- Add keybinds at the end of each line using the below format, you can skip skills that are not used.",
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

    ; Write explanation.
    for line in Explanation {
        FileAppend(line "`n", KeybindFile)
    }

    ; Write keybinds.
    FileAppend("`n-- Class spells and talents.`n", KeybindFile)
    for Name, Spell in Keybinds {
        if Spell.Type = "Class" {
            FileAppend(Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n", KeybindFile)
        }
    }

    FileAppend("`n-- Racial spells.`n", KeybindFile)
    for Name, Spell in Keybinds {
        if Spell.Type = "Common" {
            FileAppend(Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n", KeybindFile)
        }
    }

    FileAppend("`n-- Items.`n", KeybindFile)
    for Name, Spell in Keybinds {
        if Spell.Type = "Item" {
            FileAppend(Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n", KeybindFile)
        }
    }

    ; Remove backup.
    if FileExist(BackupFile) {
        FileDelete(BackupFile)
    }
}