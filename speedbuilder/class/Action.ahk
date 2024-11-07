#Include Definition.ahk

class Action {
    Name := ""
    IconID := 0
    Colors := ""
    __keybind := ""
    IsAlias := false
    __definition := false

    ; Updates
    RequiresLearning := false
    Status := {
        Alias: false,
        Icon: false,
        New: true,
        Removed: true
    }

    Keybind {
        get => this.__keybind
        set {
            this.IsAlias := (SubStr(value, 1, 1) = "@")
            this.__keybind := value
        }
    }

    Definition {
        get => this.__definition
        set {
            this.Status.Removed := !(value)
            this.__definition := value
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
                this.Status.New := false
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
        ; Save definition in action
        this.Definition := definition

        ; Name
        this.Name := definition.Name

        ; Change detection
        this.Status.Icon := (this.IconID != definition.IconID)
        this.RequiresLearning := (this.Status.Icon and !this.GetCache(true))
        this.Status.Alias := ((definition.Alias or this.IsAlias) and (this.Keybind != definition.Alias))

        return this
    }

    HasUpdates() {
        return (
            this.Status.Alias or 
            this.Status.Icon or 
            this.Status.New or 
            this.Status.Removed
        )
    }

    Update() {
        if this.Status.Alias {
            this.Keybind := this.Definition.Alias
            this.Status.Alias := false
        }

        if this.Status.Icon {
            this.IconID := this.Definition.IconID
            if !this.RequiresLearning
                this.Colors := this.GetCache()
            this.Status.Icon := false
        }
    }

    GetCache(FromDefinition := false) {
        try {
            return IniRead("Cache/cache.ini", "ColorCache", (FromDefinition) ? this.Definition.IconID : this.IconID, "")
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