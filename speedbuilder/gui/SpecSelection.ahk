#Include ..\includes\SpellBook.ahk

SpecSelection(Config) {
    ClassSpecs := GetClassSpecs()

    if !ClassSpecs.Length {
        MsgBox("No classes have been setup, please run ClassSetup.ahk", AppName)
        ExitApp()
    }

    ReOpenMessage := ""
    TrimCount := 0
    if (Config.SpecSelectionKeyBind ~= "\#") {
        ReOpenMessage .= "WindowsKey + "
        TrimCount++
    }
    if Config.SpecSelectionKeyBind ~= "\!" {
        ReOpenMessage .= "Alt + "
        TrimCount++
    }
    if Config.SpecSelectionKeyBind ~= "\^" {
        ReOpenMessage .= "Ctrl + "
        TrimCount++
    }
    if (Config.SpecSelectionKeyBind ~= "\+") {
        ReOpenMessage .= "Shift + "
        TrimCount++
    }
    if TrimCount {
        ReOpenMessage .= SubStr(Config.SpecSelectionKeyBind, TrimCount + 1)
    } else {
        ReOpenMessage .= Config.SpecSelectionKeyBind
    }

    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to play.")
    SpecGui.AddDropDownList("vClassSpecChoice r10 w360", ClassSpecs)
    LoadButton := SpecGui.AddButton("Default", "Load")
    LoadButton.OnEvent("Click", LoadButton_Click)
    SpecGui.AddText(,ReOpenMessage ": To open this menu again for spec switching.")
    SpecGui.OnEvent("Close", SpecSelectGui_Close)

    SpecGui.Show()
}

LoadButton_Click(GuiCtrlObj, Info) {
    global SelectedClassSpec
    global KeyBinds

    ; Hide parent.
    SpecSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ClassSpecChoice := SpecSelectorValues.ClassSpecChoice

    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    if !ClassSpecChoice {
        MsgBox("No class spec selected, exiting.", AppName)
        ExitApp()
    }

    SelectedClassSpec := ClassSpecChoice
    KeyBinds := GetClassKeybinds(SelectedClassSpec, Map())
}

SpecSelectGui_Close(GuiCtrlObj) {
    ExitApp()
}