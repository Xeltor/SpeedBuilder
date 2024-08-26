#Include Action.ahk
#Include Definition.ahk

class Specialization {
    Name := ""
    FileName := ""
    Actions := Map()
    HasUpdates := false

    __New(FileName, Setup := false) {
        this.FileName := StrLower(StrReplace(FileName, " ", "_"))
        this.Name := StrTitle(StrReplace(FileName, "_", " "))
        this.LoadActions(Setup)
        this.GetChanges(Setup)
    }

    GetDefinitions() {
        ; Clear definitions
        Definitions := []
    
        ; Helper function to read definitions
        readDefinitions(fileName, type) {
            filePath := "speedbuilder\definitions\" fileName ".txt"
            loop read, filePath {
                line := Trim(A_LoopReadLine)
                if (InStr(line, "--") or line = "")
                    continue
                Definitions.Push(Definition(line, type))
            }
        }
    
        ; Read common items
        readDefinitions("common_items", "Item")
    
        ; Read racial spells
        readDefinitions("common_spells", "Racial")
    
        ; Read specialization spells
        readDefinitions(this.FileName, "Spell")

        return Definitions
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

    ; Checks for updates
    GetChanges(Setup := false) {
        ; Get definitions.
        Definitions := this.GetDefinitions()

        ; Update actions from definitions.
        ActionList := []
        for Definition in Definitions {
            ; Update existing or generate from definition.
            UpdatedAction := this.Actions.Has(Definition.Name) ? this.Actions[Definition.Name].FromDefinition(Definition) : Action().FromDefinition(Definition)

            ; This spec has updates.
            if UpdatedAction.IsUpdated
                this.HasUpdates := true

            ActionList.Push(UpdatedAction)
        }

        ; Difference in the amount of skills compared to definitions.
        if this.Actions.Count != Definitions.Length
            this.HasUpdates := true
    
        if Setup
            this.Actions := ActionList
    }

    SaveActions() {
        KeybindDir := "Keybinds"
        if !DirExist(KeybindDir) {
            DirCreate(KeybindDir)
        }
    
        KeybindFile := KeybindDir "\" this.FileName ".txt"
        BackupFile := KeybindDir "\" this.FileName "_backup.txt"
    
        ; Backup existing file
        if FileExist(KeybindFile) {
            FileMove(KeybindFile, BackupFile, true)
        }

        try {
            for _, spell in this.Actions {
                FileAppend(spell.Name "," spell.IconID "," spell.Colors "," spell.Keybind "`n", keybindFile)
            }
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

            return false
        } else {
            ; Remove backup
            if FileExist(backupFile) {
                FileDelete(backupFile)
            }
        }

        return true
    }

    ChangeActionKeybind(ActionName, Keybind) {
        for _, Act in this.Actions {
            if Act.Name = ActionName {
                Act.Keybind := Keybind
            }
        }

        return
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