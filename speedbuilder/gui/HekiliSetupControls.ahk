#HotIf WinExist("HACK: Hekili setup")
Ctrl & LButton:: {
    global cfg

	MouseClick
	MouseGetPos(&xCoord, &yCoord)

    cfg.HekiliXCoord := xCoord
    cfg.HekiliYCoord := yCoord

	HekiliTarget_Draw()
}

; Increase box size.
NumpadAdd:: {
    global cfg

    if (cfg.HekiliBoxWidth + 1 <= 200) {
        cfg.HekiliBoxWidth := cfg.HekiliBoxWidth + 1
        HekiliTarget_Draw()

        if WinExist(cfg.Warcraft)
            WinActivate(cfg.Warcraft)
    }
}

; Decrease box size.
NumpadSub:: {
    global cfg

    if (cfg.HekiliBoxWidth - 1 > 25) {
        cfg.HekiliBoxWidth := cfg.HekiliBoxWidth - 1
        HekiliTarget_Draw()

        if WinExist(cfg.Warcraft)
            WinActivate(cfg.Warcraft)
    }
}

; Move left.
Left:: {
    global cfg

    cfg.HekiliXCoord := cfg.HekiliXCoord - 1
    HekiliTarget_Draw()
}

; Move right.
Right:: {
    global cfg

    cfg.HekiliXCoord := cfg.HekiliXCoord + 1
    HekiliTarget_Draw()
}

; Move up.
Up:: {
    global cfg

    cfg.HekiliYCoord := cfg.HekiliYCoord - 1
    HekiliTarget_Draw()
}

; Move down.
Down:: {
    global cfg

    cfg.HekiliYCoord := cfg.HekiliYCoord + 1
    HekiliTarget_Draw()
}
#HotIf