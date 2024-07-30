#Include Definition.ahk

class Action {
    Name := ""
    IconID := 0
    Colors := ""
    __keybind := ""
    IsAlias := false

    ; For setup
    IsUpdated := false
    ActionType := ""

    Keybind {
        get {
            return this.__keybind
        }
        set {
            this.IsAlias := (SubStr(value, 1, 1) = "@")
            this.__keybind := value
        }
    }

    __New(ActionString := "") {
        split := StrSplit(ActionString, ',')
    
        if split.Length = 4 {
            this.Name := Trim(split[1])
            this.IconID := Trim(split[2])
            this.Colors := Trim(split[3])
            this.Keybind := Trim(split[4])
        }
    }

    FromDefinition(Definition) {
        this.Name := Definition.Name
        if this.IconID != Definition.IconID {
            this.IconID := Definition.IconID
            this.IsUpdated := true
        }
        if !this.Colors
            this.IsUpdated := true
        if Definition.Alias
            this.Keybind := Definition.Alias
        this.ActionType := Definition.DefinitionType

        return this
    }
}