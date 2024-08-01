#Include Action.ahk
#Include Definition.ahk

class Specialization {
    Name := ""
    FileName := ""
    Actions := Map()
    Definitions := []

    __New(FileName, Setup := false) {
        this.FileName := StrLower(StrReplace(FileName, " ", "_"))
        this.Name := StrTitle(StrReplace(FileName, "_", " "))

        if Setup {
            this.LoadDefinitions()
        }
        this.LoadActions(Setup)
    }

    LoadDefinitions() {
        ; Clear definitions.
        this.Definitions := []

        ; Common items
        loop read, "speedbuilder\definitions\common_items.txt" {
            if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
                continue
            }
            Item := Definition(A_LoopReadLine, "Item")

            this.Definitions.Push(Item)        
        }

        ; Common spells
        loop read, "speedbuilder\definitions\common_spells.txt" {
            if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
                continue
            }
            Common := Definition(A_LoopReadLine, "Common")

            this.Definitions.Push(Common)        
        }
        
        ; Specialization spells
        loop read, "speedbuilder\definitions\" this.FileName ".txt" {
            if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
                continue
            }
            Spell := Definition(A_LoopReadLine, "Spell")

            this.Definitions.Push(Spell)        
        }
    }

    LoadActions(Setup := false) {
        KeybindFile := "Keybinds\" this.FileName ".txt"

        if !FileExist(KeybindFile)
            return

        ; Clear actions.
        this.Actions := Map()

        ; Add actions from keybind file.
        loop read, KeybindFile {
            if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
                continue
            }

            Act := Action(A_LoopReadLine)
            if Setup
                this.Actions[Act.Name] := Act
            else
                this.Actions[Act.Colors] := Act
        }
    }

    GetAlias(ActionName) {
        name := Trim(StrReplace(ActionName, "@", ""))
    
        for key, Action in this.Actions {
            if (StrLower(Action.Name) = StrLower(name)) {
                return Action.Keybind
            }
        }
        return false
    }
}