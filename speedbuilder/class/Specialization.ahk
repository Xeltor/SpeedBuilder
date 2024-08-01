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
        ; Clear definitions
        this.Definitions := []
    
        ; Helper function to read definitions
        readDefinitions(fileName, type) {
            filePath := "speedbuilder\definitions\" fileName ".txt"
            loop read, filePath {
                line := Trim(A_LoopReadLine)
                if (InStr(line, "--") or line = "")
                    continue
                this.Definitions.Push(Definition(line, type))
            }
        }
    
        ; Read common items
        readDefinitions("common_items", "Item")
    
        ; Read common spells
        readDefinitions("common_spells", "Common")
    
        ; Read specialization spells
        readDefinitions(this.FileName, "Spell")
    }

    LoadActions(Setup := false) {
        KeybindFile := "Keybinds\" this.FileName ".txt"

        if !FileExist(KeybindFile)
            return

        ; Clear actions.
        this.Actions := Map()

        ; Add actions from keybind file
        loop read, keybindFile {
            line := Trim(A_LoopReadLine)
            if (InStr(line, "--") or line = "")
                continue

            act := Action(line)
            this.Actions[Setup ? act.Name : act.Colors] := act
        }
    }

    GetActionByAlias(ActionName) {
        name := StrLower(Trim(StrReplace(ActionName, "@", "")))
    
        for _, action in this.Actions {
            if (StrLower(action.Name) = name) {
                return action.Keybind
            }
        }
        return false
    }    
}