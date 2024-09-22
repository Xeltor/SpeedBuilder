GetPixelColors(Setup:=false, Wait:=1000) {
    colors := ""

    ; Give WoW some time to respond
    if Setup {
        Sleep(Wait)
        if !WinActive(cfg.Warcraft)
            WinActivate(cfg.Warcraft)
    }

    for p in cfg.HekiliPixels() {
        colors := colors PixelGetColor(p.xCoord, p.yCoord)
    }

    return colors
}

SetIconReplacement(IconID, xCoord, yCoord) {
    WinActivate(cfg.Warcraft)
    MouseClick(, xCoord, yCoord, 2)
    Send("^a")
    Send(IconID)
    Send("{Enter}")
}

ResetIconReplacement(xCoord, yCoord) {
    WinActivate(cfg.Warcraft)
    MouseClick(, xCoord, yCoord, 2)
    Send("^a")
    Send("{Del}")
    Send("{Enter}")
}