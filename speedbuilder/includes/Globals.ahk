global Hekili := {
    Width: IniRead("config.ini", "Hekili", "BoxWidth", "50"),
    xCoord: IniRead("config.ini", "Hekili", "xCoord", "100"),
    yCoord: IniRead("config.ini", "Hekili", "yCoord", "100"),

    Pixels: [
        {
            xCoord: IniRead("config.ini", "Hekili", "xCoord", "100") - (IniRead("config.ini", "Hekili", "BoxWidth", "50") / 4),
            yCoord: IniRead("config.ini", "Hekili", "yCoord", "100") - (IniRead("config.ini", "Hekili", "BoxWidth", "50") / 4)
        },
        {
            xCoord: IniRead("config.ini", "Hekili", "xCoord", "100") - (IniRead("config.ini", "Hekili", "BoxWidth", "50") / 4),
            yCoord: IniRead("config.ini", "Hekili", "yCoord", "100") + (IniRead("config.ini", "Hekili", "BoxWidth", "50") / 4)
        }
    ]
}

global Warcraft := "ahk_class GxWindowClass"
