#Include Action.ahk
#Include Definition.ahk

class Profile {
    Name := ""
    FileName := ""
    Actions := Map()
    HasUpdates := false
    UpdateCount := 0
    RequiresLearning := false
    HasDuplicates := false
    Force := false
    ChangeLog := ""

    __New(FileName, Setup := false, LoadActions := true) {
        this.FileName := StrLower(StrReplace(FileName, " ", "_"))
        this.Name := StrTitle(StrReplace(FileName, "_", " "))
        if LoadActions {
            this.LoadActions(Setup)
        }
    }

    GetDefinitions() {
        ; Clear definitions
        Definitions := []
    
        ; Helper function to read definitions
        readDefinitions(fileName) {
            filePath := "speedbuilder\definitions\" fileName ".txt"
            loop read, filePath {
                line := Trim(A_LoopReadLine)
                if (InStr(line, "--") or line = "")
                    continue
                Definitions.Push(Definition(line))
            }
        }
    
        ; Read common items
        readDefinitions("common_items")
    
        ; Read racial spells
        readDefinitions("common_spells")
    
        ; Read specialization spells
        readDefinitions(this.FileName)

        return Definitions
    }

    LoadActions(Setup := false) {
        this.ChangeLog := ""
        this.UpdateCount := 0
        KeybindFile := "Keybinds\" this.FileName ".txt"

        ; Clear actions.
        this.Actions := Map()

        ; Get definitions
        definitions := this.GetDefinitions()
        GetDefinitionByAction(ActionName, Definitions) {
            name := StrLower(ActionName)
        
            for def in Definitions {
                if (StrLower(def.Name) = name) {
                    return def
                }
            }
            return false
        }

        ; Add actions from keybind file
        if FileExist(KeybindFile) {
            loop read, keybindFile {
                line := Trim(A_LoopReadLine)
                if (InStr(line, "--") or line = "")
                    continue

                act := Action(line)

                ; Get definition
                def := GetDefinitionByAction(act.Name, definitions)
                if def
                    act := act.FromDefinition(def)

                ; Action is gone.
                if !act.Definition {
                    this.GenerateChangeLog(Act)
                    this.HasUpdates := true
                }

                try {
                    if (this.Actions[act.Colors])
                        this.HasDuplicates := true
                }

                this.Actions[act.Colors] := act
            }
        }
        

        ; Check if definitions and actions are not the same.
        if Setup
            ActionList := []
        for Definition in definitions {
            result := this.GetActionByName(Definition.Name)

            ; Update existing or generate from definition.
            UpdatedAction := result.Found ? result.Action.FromDefinition(Definition) : Action().FromDefinition(Definition)

            ; This spec has updates.
            if UpdatedAction.HasUpdates() {
                ; Learned from cache, dont make the user do unneeded work.
                if UpdatedAction.RequiresLearning
                    this.RequiresLearning := UpdatedAction.RequiresLearning
                this.HasUpdates := true
                this.GenerateChangeLog(UpdatedAction)
            }

            if Setup
                ActionList.Push(UpdatedAction)
        }

        ; Save actions by name for setup purposes.
        if Setup {
            this.Actions := Map()
            for _, act in ActionList {
                this.Actions[act.Name] := act
            }
        }
    }

    Delete() {
        KeybindFile := "Keybinds\" this.FileName ".txt"

        if !FileExist(KeybindFile)
            return

        try {
            FileDelete(KeybindFile)
        }
    }

    ; Only update changes from cache if no new icons need to be learned.
    UpdateActions() {
        for _, Act in this.Actions {
            if Act.HasUpdates() 
                Act.Update()
        }
    }

    GenerateChangeLog(Act) {
        if Act.HasUpdates() {
            if Act.Status.New {
                this.ChangeLog .= Format("New: {}, Requires Learning: {}`n", Act.Name, Act.RequiresLearning)
            } else if Act.Status.Removed {
                this.ChangeLog .= Format("Removed: {}, Requires Learning: {}`n", Act.Name, Act.RequiresLearning)
            } else {
                this.ChangeLog .= Format("Updated: {}, Alias changed: {}, Icon changed: {}, Requires Learning: {}`n", Act.Name, Act.Status.Alias, Act.Status.Icon, Act.RequiresLearning)
            }
            this.UpdateCount += 1
        }
    }

    GenerateCache() {
        showPopup("Generating icon color cache from " this.Name " specialization.")
        for _, act in this.Actions {
            if act.Colors != "" {
                act.WriteCache()
            }
        }
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
                return action
            }
        }
        return false
    }

    GetActionByName(ActionName) {
        result := Map()
        result.Found := false

        for _, action in this.Actions {
            if (StrLower(action.Name) = StrLower(ActionName)) {
                result := {
                    Found: true,
                    Action: action
                }
                return result
            }
        }
        return result
    }

    RemoveActionByName(ActionName) {
        result := Map()

        for k, action in this.Actions {
            if (StrLower(action.Name) != StrLower(ActionName)) {
                result[k] := action
            }
        }

        this.Actions := result
    }
}