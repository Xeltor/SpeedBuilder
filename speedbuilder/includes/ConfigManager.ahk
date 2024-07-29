LoadConfig(dirOffset := "") {
    Config := {}

    ; Set warcraft window.
    Config.Warcraft := "ahk_class waApplication Window"
    Config.AliasPrefix := "@"

    ; Toggle on keybind.
    if FileExist(dirOffset "config.ini") {
        try {
            Config.ToggleOnOffKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
        } catch {
            Config.ToggleOnOffKeyBind := "``"
            IniWrite(config.ToggleOnOffKeyBind, dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
        }

        ; Spec selection keybind.
        try {
            Config.SpecSelectionKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
        } catch {
            Config.SpecSelectionKeyBind := "#F12"
            IniWrite(config.SpecSelectionKeyBind, dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
        }

        ; Hekili xCoord config.
        Config.Hekili := {}
        try {
            Config.Hekili.xCoord := IniRead(dirOffset "config.ini", "Hekili", "xCoord")
        } catch {
            Config.Hekili.xCoord := "100"
            IniWrite(config.Hekili.xCoord, dirOffset "config.ini", "Hekili", "xCoord")
        }

        ; Hekili yCoord config.
        try {
            Config.Hekili.yCoord := IniRead(dirOffset "config.ini", "Hekili", "yCoord")
        } catch {
            Config.Hekili.yCoord := "100"
            IniWrite(Config.Hekili.yCoord, dirOffset "config.ini", "Hekili", "yCoord")
        }

        ; Hekili BoxWidth config.
        try {
            Config.Hekili.BoxWidth := IniRead(dirOffset "config.ini", "Hekili", "BoxWidth")
        } catch {
            Config.Hekili.BoxWidth := "50"
            IniWrite(Config.Hekili.BoxWidth, dirOffset "config.ini", "Hekili", "BoxWidth")
        }

        ; Hekili Pixels config.
        Config.Hekili.Pixels := [
            {
                xCoord: Config.Hekili.xCoord - (Config.Hekili.BoxWidth / 4),
                yCoord: Config.Hekili.yCoord - (Config.Hekili.BoxWidth / 4)
            },
            {
                xCoord: Config.Hekili.xCoord - (Config.Hekili.BoxWidth / 4),
                yCoord: Config.Hekili.yCoord + (Config.Hekili.BoxWidth / 4)
            }
        ]
    }

    return Config
}