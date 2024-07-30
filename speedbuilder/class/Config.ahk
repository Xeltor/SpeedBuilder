class Config {
    static Warcraft := "ahk_class waApplication Window"
    static AliasPrefix := "@"
    static CurrentSpec := ""

    __New(ToggleKeybind := "``", SpecSelectionKeybind := "#F12", HekiliXCoord := 0, HekiliYCoord := 0, HekiliBoxWidth := 50) {
        this.ToggleOnOffKeyBind := ToggleKeybind
        this.SpecSelectionKeyBind := SpecSelectionKeybind
        this.HekiliXCoord := HekiliXCoord
        this.HekiliYCoord := HekiliYCoord
        this.HekiliBoxWidth := HekiliBoxWidth
    }

    ; Return calculated pixel locations array
    static HekiliPixels() {
        return [
            {
                xCoord: this.HekiliXCoord - (this.HekiliBoxWidth / 4),
                yCoord: this.HekiliYCoord - (this.HekiliBoxWidth / 4)
            },
            {
                xCoord: this.HekiliXCoord - (this.HekiliBoxWidth / 4),
                yCoord: this.HekiliYCoord + (this.HekiliBoxWidth / 4)
            }
        ]
    }

    ; Format current class spec.
    static GetFormattedCurrentSpec() {
        return StrTitle(StrReplace(this.CurrentSpec, "_", " "))
    }

    ; Write config to file.
    static SaveConfigFile(dirOffset := "") {
        IniWrite(this.ToggleOnOffKeyBind, dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
        IniWrite(this.SpecSelectionKeyBind, dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
        IniWrite(this.HekiliXCoord, dirOffset "config.ini", "Hekili", "xCoord")
        IniWrite(this.HekiliYCoord, dirOffset "config.ini", "Hekili", "yCoord")
        IniWrite(this.HekiliBoxWidth, dirOffset "config.ini", "Hekili", "BoxWidth")
    }

    ; Load config from file.
    static LoadConfigFile(dirOffset := "") {
        this.ToggleOnOffKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
        this.SpecSelectionKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
        this.HekiliXCoord := IniRead(dirOffset "config.ini", "Hekili", "xCoord")
        this.HekiliYCoord := IniRead(dirOffset "config.ini", "Hekili", "yCoord")
        this.HekiliBoxWidth := IniRead(dirOffset "config.ini", "Hekili", "BoxWidth")

        return this
    }
}