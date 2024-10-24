#Include Definition.ahk

class Action {
    Name := ""
    IconID := 0
    Colors := ""
    __keybind := ""
    IsAlias := false
    Definition := false

    ; For setup
    IsUpdated := false

    Keybind {
        get => this.__keybind
        set {
            this.IsAlias := (SubStr(value, 1, 1) = "@")
            this.__keybind := value
        }
    }

    __New(ActionString := "") {
        if ActionString {
            split := StrSplit(ActionString, ',')
            if split.Length = 4 {
                this.Name := Trim(split[1])
                this.IconID := Trim(split[2])
                this.Colors := Trim(split[3])
                this.Keybind := Trim(split[4])
            }
        }
    }

    Use() {
        act := this.IsAlias ? ActiveProfile.GetActionByAlias(this.Keybind) : this

        if !act or act.Keybind = ""
            return
    
        if act.Definition and act.Definition.Delay
            Sleep(act.Definition.Delay)
    
        Send(act.Keybind)
    }

    FromDefinition(definition) {
        this.Name := definition.Name
        this.IsUpdated := (this.IconID != definition.IconID) or !this.Colors
        this.IconID := definition.IconID
        this.Colors := this.Colors ? this.Colors : ""
        this.Keybind := definition.Alias ? definition.Alias : this.Keybind

        return this
    }

    GetCache() {
        try {
            return IniRead("Cache/cache.ini", "ColorCache", this.IconID, "")
        }
        return false
    }

    WriteCache() {
        CacheDir := "Cache"
        if !DirExist(CacheDir) {
            DirCreate(CacheDir)
        }

        try {
            IniWrite(this.Colors, "Cache/cache.ini", "ColorCache", this.IconID)
        }
    }

    ClearCache() {
        try {
            IniDelete("Cache/cache.ini", "ColorCache", this.IconID)
            return true
        }
        return false
    }
}