global KeybindListGui := ""
global KeybindSelectedRow := ""
global KeybindRowNumber := 0

KeybindList() {
    global KeybindListGui

    KeybindListGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    KeybindListGui.SetFont("s11")
    KeybindListGui.OnEvent("Close", KeybindList_Close)

    KeybindList := KeybindListGui.AddListView("Grid r20 w300 NoSortHdr Sort -Multi", ["Action", "Keybind"])

    KeybindList.OnEvent("DoubleClick", KeyBindList_DoubleClick)

    for _, val in LoadedSpec.Actions {
        if !val.IsAlias
            KeybindList.Add("", val.Name, val.Keybind)
    }

    KeybindList.ModifyCol(1, "AutoHdr")
    KeybindList.ModifyCol(2, "AutoHdr")

    KeybindListGui.Show()
}

KeyBindList_DoubleClick(KBLV, RowNumber) {
    global KeybindSelectedRow := KBLV
    global KeybindRowNumber := RowNumber

    KeybindGui := Gui("+AlwaysOnTop +ToolWindow", "Keybind")
    KeybindGui.SetFont("s11")

    KeybindGui.AddText(,"Set keybind for " KBLV.GetText(RowNumber) ":")
    Keybind := KeybindGui.AddHotkey("w200 vChosenHotkey")

    ; Remove left and right curly if exist.
    kb := StrReplace(KBLV.GetText(RowNumber, 2), "{")
    kb := StrReplace(kb, "}")
    Keybind.Value := kb

    KeybindSet := KeybindGui.AddButton("Default", "Set")
    KeybindSet.OnEvent("Click", KeybindSet_Click)

    KeybindClear := KeybindGui.AddButton("yp", "Clear")
    KeybindClear.OnEvent("Click", KeybindClear_Click)

    KeybindGui.OnEvent("Close", Keybind_Close)

    KeybindGui.Show("AutoSize")

    KeybindListGui.Opt("+Disabled")
    KeybindListGui.Hide()
}

KeybindSet_Click(GuiCtrlObj, Info) {
    KeybindValues := GuiCtrlObj.Gui.Submit(true)

    AddBracesToKeybind(Keybind) {
        SpecialKeys := [
            "Numpad0",
            "Numpad1",
            "Numpad2",
            "Numpad3",
            "Numpad4",
            "Numpad5",
            "Numpad6",
            "Numpad7",
            "Numpad8",
            "Numpad9",
            "NumpadDot",
            "NumpadEnter",
            "NumpadMult",
            "NumpadDiv",
            "NumpadAdd",
            "NumpadSub",
            "NumpadDel",
            "NumpadIns",
            "NumpadClear",
            "NumpadUp",
            "NumpadDown",
            "NumpadLeft",
            "NumpadRight",
            "NumpadHome",
            "NumpadEnd",
            "Up",
            "Down",
            "Left",
            "Right",
            "Home",
            "End",
            "PgUp",
            "PgDn",
            "Insert",
            "Backspace",
            "F12",
            "F11",
            "F10",
            "F9",
            "F8",
            "F7",
            "F6",
            "F5",
            "F4",
            "F3",
            "F2",
            "F1",
        ]

        for sk in SpecialKeys {
            if InStr(Keybind, sk) {
                return StrReplace(Keybind, sk, "{" sk "}")
            }
        }

        return Keybind
    }

    ; Set new keybind.
    NewKeybind := AddBracesToKeybind(KeybindValues.ChosenHotkey)
    KeybindSelectedRow.Modify(KeybindRowNumber, "Col2", NewKeybind)
    LoadedSpec.ChangeActionKeybind(KeybindSelectedRow.GetText(KeybindRowNumber), NewKeybind)

    ; Destroy and unlock parent.
    GuiCtrlObj.Gui.Destroy()
    KeybindListGui.Opt("-Disabled")
    KeybindListGui.Show()
}

KeybindClear_Click(GuiCtrlObj, Info) {
    ; Clear keybind.
    KeybindSelectedRow.Modify(KeybindRowNumber, "Col2", "")
    LoadedSpec.ChangeActionKeybind(KeybindSelectedRow.GetText(KeybindRowNumber), "")

    ; Destroy and unlock parent.
    GuiCtrlObj.Gui.Destroy()
    KeybindListGui.Opt("-Disabled")
    KeybindListGui.Show()
}

KeybindList_Close(GuiCtrlObj) {
    ; Save to file.
    LoadedSpec.SaveActions()

    ; Return to spec selection gui.
    SpecSelectionGui()
}

; Cancel opteration.
Keybind_Close(GuiCtrlObj) {
    KeybindListGui.Opt("-Disabled")
    KeybindListGui.Show()
}