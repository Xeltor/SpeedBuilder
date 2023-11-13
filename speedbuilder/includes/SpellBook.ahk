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

            Spell.Name := StrLower(Trim(split[1]))
            Spell.IconID := Trim(split[2])
            Spell.Colors := ""
            Spell.Keybind := ""
            Spell.Updated := true

            Spellbook[Spell.Name] := Spell
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

            Item.Name := StrLower(Trim(split[1]))
            Item.IconID := Trim(split[2])
            Item.Colors := ""
            Item.Keybind := ""
            Item.Updated := true

            Items[Item.Name] := Item
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

            Spell.Name := StrLower(Trim(split[1]))
            Spell.IconID := Trim(split[2])
            Spell.Colors := ""
            Spell.Keybind := ""
            Spell.Updated := true

            Spellbook[Spell.Name] := Spell
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

            Spell.Name := StrLower(Trim(split[1]))
            Spell.IconID := Trim(split[2])
            Spell.Colors := Trim(split[3])
            Spell.Keybind := Trim(split[4])

            if ByName {
                ; Remove spells no longer in the definition.
                try {
                    if Spellbook[Spell.Name] {
                        ; Check if the IconID is different from the keybind file.
                        if Spellbook[Spell.Name].IconID != Spell.IconID {
                            Spellbook[Spell.Name].Updated := true
                        } else {
                            Spellbook[Spell.Name].Updated := false
                        }

                        Spellbook[Spell.Name].Colors := Spell.Colors
                        Spellbook[Spell.Name].Keybind := Spell.Keybind
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
    if FileExist(KeybindFile){
        FileDelete(KeybindFile)
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
        "-- Example2: Control + Alt + 1 = ^!1",
        ""
    ]

    ; Write explanation.
    for line in Explanation {
        FileAppend(line "`n", KeybindFile)
    }

    ; Write keybinds.
    for IconID, Spell in Keybinds {
        FileAppend(Spell.Name "," Spell.IconID "," Spell.Colors "," Spell.Keybind "`n", KeybindFile)
    }
}