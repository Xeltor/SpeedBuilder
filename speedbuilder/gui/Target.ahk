; Define controls.
#HotIf TargetGui != "" and WinActive(Warcraft)
Ctrl & LButton:: {
    global TargetGui
    global Hekili

	MouseClick
	MouseGetPos(&xCoord, &yCoord)

    Hekili.xCoord := xCoord
    Hekili.yCoord := yCoord

    IniWrite(xCoord, "config.ini", "Hekili", "xCoord")
    IniWrite(yCoord, "config.ini", "Hekili", "yCoord")

	TargetGui := DrawTargetGui(Hekili, TargetGui)
}

; Increase box size.
NumpadAdd:: {
    global TargetGui
    global Hekili

    if (Hekili.Width + 1 <= 100) {
        Hekili.Width := Hekili.Width + 1
        IniWrite(Hekili.Width, "config.ini", "Hekili", "BoxWidth")
        TargetGui := DrawTargetGui(Hekili, TargetGui, True)

        WinActivate(Warcraft)
    }
}

; Decrease box size.
NumpadSub:: {
    global TargetGui
    global Hekili

    if (Hekili.Width + 1 > 25) {
        Hekili.Width := Hekili.Width - 1
        IniWrite(Hekili.Width, "config.ini", "Hekili", "BoxWidth")
        TargetGui := DrawTargetGui(Hekili, TargetGui, True)

        WinActivate(Warcraft)
    }
}

; Move left.
Left:: {
    global TargetGui
    global Hekili

    Hekili.xCoord := Hekili.xCoord - 1
    IniWrite(Hekili.xCoord, "config.ini", "Hekili", "xCoord")
    TargetGui := DrawTargetGui(Hekili, TargetGui)
}

; Move right.
Right:: {
    global TargetGui
    global Hekili

    Hekili.xCoord := Hekili.xCoord + 1
    IniWrite(Hekili.xCoord, "config.ini", "Hekili", "xCoord")
    TargetGui := DrawTargetGui(Hekili, TargetGui)
}

; Move up.
Up:: {
    global TargetGui
    global Hekili

    Hekili.yCoord := Hekili.yCoord - 1
    IniWrite(Hekili.yCoord, "config.ini", "Hekili", "yCoord")
    TargetGui := DrawTargetGui(Hekili, TargetGui)
}

; Move down.
Down:: {
    global TargetGui
    global Hekili

    Hekili.yCoord := Hekili.yCoord + 1
    IniWrite(Hekili.yCoord, "config.ini", "Hekili", "yCoord")
    TargetGui := DrawTargetGui(Hekili, TargetGui)
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
        TargetGui.AddPicture("h" Hekili.Width " w-1 X-0 Y-0", "speedbuilder\resources\bullseye.gif")
        WinSetTransColor("0xFF00FF", TargetGui)
        TargetGui.Opt("-Caption +Disabled")

        TargetGui.Show("x" (Hekili.xCoord - (Hekili.Width / 2)) " y" (Hekili.yCoord - (Hekili.Width / 2)) " w" Hekili.Width " h" Hekili.Width)
    } else {
        TargetGui.Move((Hekili.xCoord - (Hekili.Width / 2)), (Hekili.yCoord - (Hekili.Width / 2)))
    }

    return TargetGui
}