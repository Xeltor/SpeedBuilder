LoadConfig() {
    Config := {}

    ; Set warcraft window.
    Config.Warcraft := "ahk_class GxWindowClass"

    ; Toggle on keybind.
    try {
        Config.ToggleOnOffKeyBind := IniRead("config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
    } catch {
        Config.ToggleOnOffKeyBind := "``"
        IniWrite(config.ToggleOnOffKeyBind, "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")
    }

    ; Spec selection keybind.
    try {
        Config.SpecSelectionKeyBind := IniRead("config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
    } catch {
        Config.SpecSelectionKeyBind := "#F12"
        IniWrite(config.SpecSelectionKeyBind, "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")
    }

    ; Hekili xCoord config.
    Config.Hekili := {}
    try {
        Config.Hekili.xCoord := IniRead("config.ini", "Hekili", "xCoord")
    } catch {
        Config.Hekili.xCoord := "100"
        IniWrite(config.Hekili.xCoord, "config.ini", "Hekili", "xCoord")
    }

    ; Hekili yCoord config.
    try {
        Config.Hekili.yCoord := IniRead("config.ini", "Hekili", "yCoord")
    } catch {
        Config.Hekili.yCoord := "100"
        IniWrite(Config.Hekili.yCoord, "config.ini", "Hekili", "yCoord")
    }

    ; Hekili BoxWidth config.
    try {
        Config.Hekili.BoxWidth := IniRead("config.ini", "Hekili", "BoxWidth")
    } catch {
        Config.Hekili.BoxWidth := "50"
        IniWrite(Config.Hekili.BoxWidth, "config.ini", "Hekili", "BoxWidth")
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

    return Config
}