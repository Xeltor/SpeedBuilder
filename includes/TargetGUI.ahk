; Define controls.
#HotIf TargetGui != "" and WinActive(Warcraft)
LButton:: {
    global TargetGui
    global xCoord
    global yCoord
    global BoxWidth

	MouseClick
	MouseGetPos(&xCoord, &yCoord)

    IniWrite(xCoord, "config.ini", "Hekili", "xCoord")
    IniWrite(yCoord, "config.ini", "Hekili", "yCoord")

	TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth, TargetGui)
}

; Increase box size.
NumpadAdd:: {
    global TargetGui
    global xCoord
    global yCoord
    global BoxWidth

    if (BoxWidth + 1 <= 100) {
        BoxWidth := BoxWidth + 1
        IniWrite(BoxWidth, "config.ini", "Hekili", "BoxWidth")
        TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth, TargetGui, True)
    }
}

; Decrease box size.
NumpadSub:: {
    global TargetGui
    global xCoord
    global yCoord
    global BoxWidth

    if (BoxWidth + 1 > 25) {
        BoxWidth := BoxWidth - 1
        IniWrite(BoxWidth, "config.ini", "Hekili", "BoxWidth")
        TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth, TargetGui, True)
    }
}

; Move left.
Left:: {
    global TargetGui
    global xCoord
    global yCoord
    global BoxWidth

    xCoord := xCoord - 1
    IniWrite(xCoord, "config.ini", "Hekili", "xCoord")
    TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth, TargetGui)
}

; Move right.
Right:: {
    global TargetGui
    global xCoord
    global yCoord
    global BoxWidth

    xCoord := xCoord + 1
    IniWrite(xCoord, "config.ini", "Hekili", "xCoord")
    TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth, TargetGui)
}

; Move up.
Up:: {
    global TargetGui
    global xCoord
    global yCoord
    global BoxWidth

    yCoord := yCoord - 1
    IniWrite(yCoord, "config.ini", "Hekili", "yCoord")
    TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth, TargetGui)
}

; Move down.
Down:: {
    global TargetGui
    global xCoord
    global yCoord
    global BoxWidth

    yCoord := yCoord + 1
    IniWrite(yCoord, "config.ini", "Hekili", "yCoord")
    TargetGui := DrawTargetGui(xCoord, yCoord, BoxWidth, TargetGui)
}
#HotIf

; Draw gui.
DrawTargetGui(xCoord, yCoord, BoxWidth, LocateGui := "", Destroy := False) {
    if (Destroy and LocateGui != "") {
        LocateGui.Destroy()
        LocateGui := ""
    }

    if (LocateGui = "") {
        LocateGui := Gui("+E0x20 +ToolWindow +LastFound +AlwaysOnTop")
        LocateGui.AddPicture("h" BoxWidth " w-1 X-0 Y-0", "resources\bullseye.gif")
        WinSetTransColor("0xFF00FF", LocateGui)
        LocateGui.Opt("-Caption +Disabled")

        LocateGui.Show("x" (xCoord - (BoxWidth / 2)) " y" (yCoord - (BoxWidth / 2)) " w" BoxWidth " h" BoxWidth)
    } else {
        LocateGui.Move((xCoord - (BoxWidth / 2)), (yCoord - (BoxWidth / 2)))
    }

    return LocateGui
}