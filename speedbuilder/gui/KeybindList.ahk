#Include ../class/IconImage.ahk

global KeybindListGui := ""
global KeybindSelectedRow := ""
global KeybindRowNumber := 0
global KeybindListView := ""

KeybindList() {
    global KeybindListGui
    global KeybindListView

    KeybindListGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    KeybindListGui.SetFont("s11")
    KeybindListGui.OnEvent("Close", KeybindList_Close)

    ; Add user instruction
    KeybindListGui.AddText(,"Click to change the keybind.")

    ; Create listview
    KeybindListView := KeybindListGui.AddListView("Grid r20 w300 NoSortHdr Sort -Multi", ["Action", "Keybind"])

    ; Add a click event
    KeybindListView.OnEvent("Click", KeyBindList_Click)

    ; Add all actions and their respective keybinds
    AliasText := ""
    for _, val in ActiveProfile.Actions {
        if !val.IsAlias
            KeybindListView.Add("", val.Name, val.Keybind)
        if val.IsAlias and !InStr(val.Keybind, "@Trinket Macro")
            AliasText .= val.Name " -> " StrReplace(val.Keybind, "@") "`n"
    }

    ; Make an editbox that has the list of aliases.
    if AliasText {
        KeybindListGui.AddText("ys", "List of aliased spells.")
        KeybindListGui.AddEdit("r26 ReadOnly -VScroll", Sort(AliasText))
    }

    ; Auto scale the list
    KeybindListView.ModifyCol(1, "200")
    KeybindListView.ModifyCol(2, "AutoHdr")

    ; Add save button
    SaveButton := KeybindListGui.AddButton("xs" ,"Save")
    SaveButton.OnEvent("Click", KeybindListSave_Click)

    ; Add clear all button
    ClearAllButton := KeybindListGui.AddButton("yp", "Clear all")
    ClearAllButton.OnEvent("Click", KeybindListClearAll_Click)

    KeybindListGui.Show()
}

KeyBindList_Click(KBLV, RowNumber) {
    global KeybindSelectedRow := KBLV
    global KeybindRowNumber := RowNumber

    KeybindGui := Gui("+AlwaysOnTop +ToolWindow", "Keybind")
    KeybindGui.SetFont("s11")

    Result := ActiveProfile.GetActionByName(KBLV.GetText(RowNumber))
    if Result.Found and IconImage(Result.Action.IconID).Cached()
        KeybindGui.AddPicture("Section w50 h50", IconImage(Result.Action.IconID).File)
    else
        KeybindGui.AddPicture("Section w50 h50", IconImage(0).File)
    KeybindGui.AddText("ys", KBLV.GetText(RowNumber))
    Keybind := KeybindGui.AddHotkey("xp w200 vChosenHotkey")

    ; Remove left and right curly if exist.
    kb := StrReplace(KBLV.GetText(RowNumber, 2), "{")
    kb := StrReplace(kb, "}")
    Keybind.Value := kb

    KeybindSet := KeybindGui.AddButton("Default xp", "Set")
    KeybindSet.OnEvent("Click", KeybindSet_Click)

    KeybindClear := KeybindGui.AddButton("yp", "Clear")
    KeybindClear.OnEvent("Click", KeybindClear_Click)

    KeybindForget := KeybindGui.AddButton("xp+95", "Forget")
    KeybindForget.OnEvent("Click", KeybindForget_Click)

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
    ActiveProfile.ChangeActionKeybind(KeybindSelectedRow.GetText(KeybindRowNumber), NewKeybind)

    ; Destroy and unlock parent.
    GuiCtrlObj.Gui.Destroy()
    KeybindListGui.Opt("-Disabled")
    KeybindListGui.Show()
}

KeybindClear_Click(GuiCtrlObj, Info) {
    ; Clear keybind.
    KeybindSelectedRow.Modify(KeybindRowNumber, "Col2", "")
    ActiveProfile.ChangeActionKeybind(KeybindSelectedRow.GetText(KeybindRowNumber), "")

    ; Destroy and unlock parent.
    GuiCtrlObj.Gui.Destroy()
    KeybindListGui.Opt("-Disabled")
    KeybindListGui.Show()
}

KeybindList_Close(GuiCtrlObj) {
    ; Make sure the user wants this.
    if MsgBox("Are you sure you wish to close the keybind list without saving?", AppName, "0x40124") = "No" {
        return
    }

    ; Return to main menu.
    MainWindow()
}

KeybindListSave_Click(GuiCtrlObj, Info) {
    GuiCtrlObj.Gui.Destroy()

    ; Save to file.
    ActiveProfile.SaveActions()

    ; Return to main menu.
    MainWindow()
}

KeybindListClearAll_Click(GuiCtrlObj, Info) {
    global KeybindListView

    ; Make sure the user wants this.
    if MsgBox("Are you sure you wish to clear all keybinds?", AppName, "0x1124") = "No" {
        return
    }

    ; Get the total number of rows in the ListView
    RowCount := KeybindListView.GetCount()

    ; Iterate through each row and clear the keybind (Column 2)
    Loop RowCount
    {
        KeybindListView.Modify(A_Index, "Col2", "")  ; Clear the keybind in the second column

        ActionName := KeybindListView.GetText(A_Index, 1)  ; Get the action name from Column 1
        ActiveProfile.ChangeActionKeybind(ActionName, "")  ; Clear the keybind in the data model
    }
}

; Cancel opteration.
Keybind_Close(GuiCtrlObj) {
    KeybindListGui.Opt("-Disabled")
    KeybindListGui.Show()
}

KeybindForget_Click(GuiCtrlObj, Info) {
    if MsgBox("This will make HACK forget the ability entirely!`n`nContinue?", AppName, "0x1124") = "No" {
        return
    }
    global ActiveProfile
    
    ; Destroy the keybind ui
    GuiCtrlObj.gui.Destroy()

    ; Get the ability name
    ActionName := KeybindSelectedRow.GetText(KeybindRowNumber)

    ; Get the ability
    result := ActiveProfile.GetActionByName(ActionName)

    ; Remote the icon from cache
    result.Action.ClearCache()
    ActiveProfile.RemoveActionByName(ActionName)

    ; Remove ability from the list
    KeybindListView.Delete(KeybindRowNumber)

    ; Save to file.
    ActiveProfile.SaveActions()

    ; Open Keybbind list gui
    KeybindListGui.Opt("-Disabled")
    KeybindListGui.Show()
}