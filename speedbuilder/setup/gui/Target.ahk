; Define controls.
#HotIf TargetGui != "" and WinActive(Config.Warcraft)
Ctrl & LButton:: {
    global TargetGui
    global Config

	MouseClick
	MouseGetPos(&xCoord, &yCoord)

    Config.Hekili.xCoord := xCoord
    Config.Hekili.yCoord := yCoord

    IniWrite(Config.Hekili.xCoord, "..\..\config.ini", "Hekili", "xCoord")
    IniWrite(Config.Hekili.yCoord, "..\..\config.ini", "Hekili", "yCoord")

	TargetGui := DrawTargetGui(Config.Hekili, TargetGui)
}

; Increase box size.
NumpadAdd:: {
    global TargetGui
    global Config

    if (Config.Hekili.BoxWidth + 1 <= 100) {
        Config.Hekili.BoxWidth := Config.Hekili.BoxWidth + 1
        IniWrite(Config.Hekili.BoxWidth, "..\..\config.ini", "Hekili", "BoxWidth")
        TargetGui := DrawTargetGui(Config.Hekili, TargetGui, True)

        WinActivate(Config.Warcraft)
    }
}

; Decrease box size.
NumpadSub:: {
    global TargetGui
    global Config

    if (Config.Hekili.BoxWidth + 1 > 25) {
        Config.Hekili.BoxWidth := Config.Hekili.BoxWidth - 1
        IniWrite(Config.Hekili.BoxWidth, "..\..\config.ini", "Hekili", "BoxWidth")
        TargetGui := DrawTargetGui(Config.Hekili, TargetGui, True)

        WinActivate(Config.Warcraft)
    }
}

; Move left.
Left:: {
    global TargetGui
    global Config

    Config.Hekili.xCoord := Config.Hekili.xCoord - 1
    IniWrite(Config.Hekili.xCoord, "..\..\config.ini", "Hekili", "xCoord")
    TargetGui := DrawTargetGui(Config.Hekili, TargetGui)
}

; Move right.
Right:: {
    global TargetGui
    global Config

    Config.Hekili.xCoord := Config.Hekili.xCoord + 1
    IniWrite(Config.Hekili.xCoord, "..\..\config.ini", "Hekili", "xCoord")
    TargetGui := DrawTargetGui(Config.Hekili, TargetGui)
}

; Move up.
Up:: {
    global TargetGui
    global Config

    Config.Hekili.yCoord := Config.Hekili.yCoord - 1
    IniWrite(Config.Hekili.yCoord, "..\..\config.ini", "Hekili", "yCoord")
    TargetGui := DrawTargetGui(Config.Hekili, TargetGui)
}

; Move down.
Down:: {
    global TargetGui
    global Config

    Config.Hekili.yCoord := Config.Hekili.yCoord + 1
    IniWrite(Config.Hekili.yCoord, "..\..\config.ini", "Hekili", "yCoord")
    TargetGui := DrawTargetGui(Config.Hekili, TargetGui)
}
#HotIf

; Draw gui.
DrawTargetGui(Hekili, TargetGui := "", Destroy := False) {
    if (Destroy and TargetGui != "") {
        TargetGui.Destroy()
        TargetGui := ""
    }

    if (TargetGui = "") {
        TargetGui := Gui("+E0x20 +ToolWindow +LastFound +AlwaysOnTop")
        TargetGui.AddPicture("h" Hekili.BoxWidth " w-1 X-0 Y-0", "resources\bullseye.gif")
        WinSetTransColor("0xFF00FF", TargetGui)
        TargetGui.Opt("-Caption +Disabled")

        TargetGui.Show("x" (Hekili.xCoord - (Hekili.BoxWidth / 2)) " y" (Hekili.yCoord - (Hekili.BoxWidth / 2)) " w" Hekili.BoxWidth " h" Hekili.BoxWidth)
    } else {
        TargetGui.Move((Hekili.xCoord - (Hekili.BoxWidth / 2)), (Hekili.yCoord - (Hekili.BoxWidth / 2)))
    }

    return TargetGui
}