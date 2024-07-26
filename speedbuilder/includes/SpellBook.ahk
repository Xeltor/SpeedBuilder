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

        if (split.Length >= 2 and split.Length <=3) {
            Spell := Object()

            Spell.Name := Trim(split[1])
            Spell.IconID := Trim(split[2])
            Spell.Colors := ""
            Spell.Keybind := (split.Length = 3) ? Trim(split[3]) : ""
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
                        ; Overwrite user keybind choice for remapped spells.
                        if !InStr(Spellbook[StrLower(Spell.Name)].Keybind, "=") {
                            Spellbook[StrLower(Spell.Name)].Keybind := Spell.Keybind
                        }
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
        "`n-- Do not change anything below this point.`n"
    ]

    ; Write Header.
    for line in Header {
        FileAppend(line "`n", KeybindFile)
    }

    ; Write keybinds.
    FileAppend("`n-- Class spells and talents.`n", KeybindFile)
    for Name, Spell in Keybinds {
        if Spell.Type = "Class" {
            SpellLine := Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n"
            if InStr(Spell.Keybind, "=")
                Footer.Push(SpellLine)
            else
                FileAppend(SpellLine, KeybindFile)
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