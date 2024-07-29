LoadConfig(dirOffset := "") {
    Config := {}

    ; Set warcraft window.
    Config.Warcraft := "ahk_class waApplication Window"
    Config.AliasPrefix := "@"

    ; Toggle on keybind.
    if FileExist(dirOffset "config.ini") {
        Config.ToggleOnOffKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")

        ; Spec selection keybind.
        Config.SpecSelectionKeyBind := IniRead(dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")

        ; Hekili xCoord config.
        Config.Hekili := {}
        Config.Hekili.xCoord := IniRead(dirOffset "config.ini", "Hekili", "xCoord")

        ; Hekili yCoord config.
        Config.Hekili.yCoord := IniRead(dirOffset "config.ini", "Hekili", "yCoord")

        ; Hekili BoxWidth config.
        Config.Hekili.BoxWidth := IniRead(dirOffset "config.ini", "Hekili", "BoxWidth")

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

GenerateConfig(dirOffset := "") {
    ; Toggle on/off keybind.
    IniWrite("``", dirOffset "config.ini", "SpeedBuilder", "ToggleOnOffKeyBind")

    ; Main window keybind
    IniWrite("#F12", dirOffset "config.ini", "SpeedBuilder", "SpecSelectionKeyBind")

    ; Hekili xCoord config.
    IniWrite("100", dirOffset "config.ini", "Hekili", "xCoord")

    ; Hekili yCoord config.
    IniWrite("100", dirOffset "config.ini", "Hekili", "yCoord")

    ; Hekili BoxWidth config.
    IniWrite("50", dirOffset "config.ini", "Hekili", "BoxWidth")

    ; Return fresh config.
    return LoadConfig(dirOffset)
}