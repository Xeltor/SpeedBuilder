class Config {
    Warcraft := "ahk_class waApplication Window"
    AliasPrefix := "@"
    ToggleState := false
    TickRate := 1000 / 60
    ToggleKeybind := "``"
    SpecSelectionKeybind := "#F12"
    HekiliXCoord := 0
    HekiliYCoord := 0
    HekiliBoxWidth := 50

    __New(ToggleKeybind := "``", SpecSelectionKeybind := "#F12", HekiliXCoord := 0, HekiliYCoord := 0, HekiliBoxWidth := 50) {
        this.ToggleOnOffKeyBind := ToggleKeybind
        this.SpecSelectionKeyBind := SpecSelectionKeybind
        this.HekiliXCoord := HekiliXCoord
        this.HekiliYCoord := HekiliYCoord
        this.HekiliBoxWidth := HekiliBoxWidth
    }

    ; Return calculated pixel locations array
    HekiliPixels() {
        offSet := this.HekiliBoxWidth / 4
        x := this.HekiliXCoord
        y := this.HekiliYCoord
    
        return [
            { xCoord: x - offSet, yCoord: y - offSet },
            { xCoord: x - offSet, yCoord: y + offSet }
        ]
    }

    ; Write config to file.
    SaveConfigFile(Setup := false) {
        dirOffset := Setup ? "..\..\" : ""
        configFile := dirOffset "config.ini"
    
        IniWrite(this.ToggleOnOffKeyBind, configFile, "SpeedBuilder", "ToggleOnOffKeyBind")
        IniWrite(this.SpecSelectionKeyBind, configFile, "SpeedBuilder", "SpecSelectionKeyBind")
        IniWrite(this.HekiliXCoord, configFile, "Hekili", "xCoord")
        IniWrite(this.HekiliYCoord, configFile, "Hekili", "yCoord")
        IniWrite(this.HekiliBoxWidth, configFile, "Hekili", "BoxWidth")
    }

    ; Load config from file.
    LoadConfigFile(Setup := false) {
        dirOffset := Setup ? "..\..\" : ""
        configFile := dirOffset "config.ini"
    
        this.ToggleOnOffKeyBind := IniRead(configFile, "SpeedBuilder", "ToggleOnOffKeyBind")
        this.SpecSelectionKeyBind := IniRead(configFile, "SpeedBuilder", "SpecSelectionKeyBind")
        this.HekiliXCoord := IniRead(configFile, "Hekili", "xCoord")
        this.HekiliYCoord := IniRead(configFile, "Hekili", "yCoord")
        this.HekiliBoxWidth := IniRead(configFile, "Hekili", "BoxWidth")
    
        return this
    }

    ; Does config exist?
    ConfigFileExists(Setup := false) {
        dirOffset := Setup ? "..\..\" : ""
    
        return FileExist(dirOffset "config.ini")
    }
}