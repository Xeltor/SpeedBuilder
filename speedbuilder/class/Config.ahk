class Config {
    Warcraft := "ahk_class waApplication Window"
    AliasPrefix := "@"
    ToggleState := false
    TickRate := 1000 / 60

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
        return [
            {
                xCoord: this.HekiliXCoord - offSet,
                yCoord: this.HekiliYCoord - offSet
            },
            {
                xCoord: this.HekiliXCoord - offSet,
                yCoord: this.HekiliYCoord + offSet
            }
        ]
    }

    ; Write config to file.
    SaveConfigFile(Setup := false) {
        dirOffset := (Setup) ? "..\..\" : ""

        IniWrite(this.ToggleOnOffKeyBind, dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
        IniWrite(this.SpecSelectionKeyBind, dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
        IniWrite(this.HekiliXCoord, dirOffset "config.ini", "Hekili", "xCoord")
        IniWrite(this.HekiliYCoord, dirOffset "config.ini", "Hekili", "yCoord")
        IniWrite(this.HekiliBoxWidth, dirOffset "config.ini", "Hekili", "BoxWidth")
    }

    ; Load config from file.
    LoadConfigFile(Setup := false) {
        dirOffset := (Setup) ? "..\..\" : ""

        this.ToggleOnOffKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
        this.SpecSelectionKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
        this.HekiliXCoord := IniRead(dirOffset "config.ini", "Hekili", "xCoord")
        this.HekiliYCoord := IniRead(dirOffset "config.ini", "Hekili", "yCoord")
        this.HekiliBoxWidth := IniRead(dirOffset "config.ini", "Hekili", "BoxWidth")

        return this
    }

    ; Does config exist?
    ConfigFileExists(Setup := false) {
        dirOffset := (Setup) ? "..\..\" : ""
    
        return FileExist(dirOffset "config.ini")
    }
}