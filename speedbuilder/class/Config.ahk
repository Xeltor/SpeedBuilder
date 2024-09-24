class Config {
    Warcraft := "ahk_class waApplication Window"
    AliasPrefix := "@"
    ToggleState := false
    TickRate := 1000 / 60
    ToggleKeybind := "``"
    MainWindowKeybind := "#F12"
    HekiliXCoord := A_ScreenWidth / 2
    HekiliYCoord := A_ScreenHeight / 2
    HekiliBoxWidth := 50

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
    Save() {
        configFile := "config.ini"
    
        IniWrite(this.ToggleKeyBind, configFile, "SpeedBuilder", "ToggleOnOffKeyBind")
        IniWrite(this.MainWindowKeybind, configFile, "SpeedBuilder", "SpecSelectionKeyBind")
        IniWrite(this.HekiliXCoord, configFile, "Hekili", "xCoord")
        IniWrite(this.HekiliYCoord, configFile, "Hekili", "yCoord")
        IniWrite(this.HekiliBoxWidth, configFile, "Hekili", "BoxWidth")
    }

    ; Load config from file.
    Load() {
        configFile := "config.ini"
    
        this.ToggleKeyBind := IniRead(configFile, "SpeedBuilder", "ToggleOnOffKeyBind")
        this.MainWindowKeybind := IniRead(configFile, "SpeedBuilder", "SpecSelectionKeyBind")
        this.HekiliXCoord := IniRead(configFile, "Hekili", "xCoord")
        this.HekiliYCoord := IniRead(configFile, "Hekili", "yCoord")
        this.HekiliBoxWidth := IniRead(configFile, "Hekili", "BoxWidth")
    
        return this
    }

    ; Does config exist?
    Exists() {
        return FileExist("config.ini")
    }
}