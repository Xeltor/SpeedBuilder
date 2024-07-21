GetPixelColors(Setup:=false) {
    colors := ""

    ; Give WoW some time to respond
    if Setup {
        Sleep(1000)
        WinActivate(Config.Warcraft)
    }

    for p in Config.Hekili.Pixels {
        colors := colors PixelGetColor(p.xCoord, p.yCoord)
    }

    return colors
}

SetIconReplacement(IconID, xCoord, yCoord) {
    WinActivate(Config.Warcraft)
    MouseClick(, xCoord, yCoord, 2)
    Send("^a")
    Send(IconID)
    Send("{Enter}")
}

ResetIconReplacement(xCoord, yCoord) {
    WinActivate(Config.Warcraft)
    MouseClick(, xCoord, yCoord, 2)
    Send("^a")
    Send("{Del}")
    Send("{Enter}")
}