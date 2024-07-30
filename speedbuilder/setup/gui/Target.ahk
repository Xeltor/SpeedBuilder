; Define controls.
#HotIf TargetGui != "" and WinActive(cfg.Warcraft)
Ctrl & LButton:: {
    global TargetGui
    global cfg

	MouseClick
	MouseGetPos(&xCoord, &yCoord)

    cfg.HekiliXCoord := xCoord
    cfg.HekiliYCoord := yCoord

	TargetGui := DrawTargetGui(cfg.Hekili, TargetGui)
}

; Increase box size.
NumpadAdd:: {
    global TargetGui
    global cfg

    if (cfg.HekiliBoxWidth + 1 <= 100) {
        cfg.HekiliBoxWidth := cfg.HekiliBoxWidth + 1
        TargetGui := DrawTargetGui(TargetGui, True)

        WinActivate(cfg.Warcraft)
    }
}

; Decrease box size.
NumpadSub:: {
    global TargetGui
    global cfg

    if (cfg.HekiliBoxWidth + 1 > 25) {
        cfg.HekiliBoxWidth := cfg.HekiliBoxWidth - 1
        TargetGui := DrawTargetGui(TargetGui, True)

        WinActivate(cfg.Warcraft)
    }
}

; Move left.
Left:: {
    global TargetGui
    global cfg

    cfg.HekiliXCoord := cfg.HekiliXCoord - 1
    TargetGui := DrawTargetGui(TargetGui)
}

; Move right.
Right:: {
    global TargetGui
    global cfg

    cfg.HekiliXCoord := cfg.HekiliXCoord + 1
    TargetGui := DrawTargetGui(TargetGui)
}

; Move up.
Up:: {
    global TargetGui
    global cfg

    cfg.HekiliYCoord := cfg.HekiliYCoord - 1
    TargetGui := DrawTargetGui(TargetGui)
}

; Move down.
Down:: {
    global TargetGui
    global cfg

    cfg.HekiliYCoord := cfg.HekiliYCoord + 1
    TargetGui := DrawTargetGui(TargetGui)
}
#HotIf

; Draw gui.
DrawTargetGui(TargetGui := "", Destroy := False) {
    if (Destroy and TargetGui != "") {
        TargetGui.Destroy()
        TargetGui := ""
    }

    if (TargetGui = "") {
        TargetGui := Gui("+E0x20 +ToolWindow +LastFound +AlwaysOnTop")
        TargetGui.AddPicture("h" cfg.HekiliBoxWidth " w-1 X-0 Y-0", "resources\bullseye.gif")
        WinSetTransColor("0xFF00FF", TargetGui)
        TargetGui.Opt("-Caption +Disabled")

        TargetGui.Show("x" (cfg.HekiliXCoord - (cfg.HekiliBoxWidth / 2)) " y" (cfg.HekiliYCoord - (cfg.HekiliBoxWidth / 2)) " w" cfg.HekiliBoxWidth " h" cfg.HekiliBoxWidth)
    } else {
        TargetGui.Move((cfg.HekiliXCoord - (cfg.HekiliBoxWidth / 2)), (cfg.HekiliYCoord - (cfg.HekiliBoxWidth / 2)))
    }

    return TargetGui
}