#Include Action.ahk
#Include Definition.ahk

class Specialization {
    Name := ""
    FileName := ""
    Actions := Map()
    Definitions := []

    __New(FileName) {
        this.FileName := StrLower(StrReplace(FileName, " ", "_"))
        this.Name := StrTitle(StrReplace(FileName, "_", " "))
    }

    LoadSetup() {
        this.LoadDefinitions()
        this.LoadActions(true)

        return this
    }

    LoadDefinitions() {
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

        return this
    }

    LoadActions(ByName := false) {
        KeybindFile := "Keybinds\" this.FileName ".txt"

        if !FileExist(KeybindFile)
            return this

        loop read, KeybindFile {
            if InStr(A_LoopReadLine, "--") or Trim(A_LoopReadLine) = "" {
                continue
            }

            Act := Action(A_LoopReadLine)
            if ByName
                this.Actions[Act.Name] := Act
            else
                this.Actions[Act.Colors] := Act
        }

        return this
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