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

    ; Load spec
    LoadButton := SpecGui.AddButton("Default Section", "Load spec")
    LoadButton.OnEvent("Click", LoadButton_Click)

    ; (Re)create spec
    CreateSpecButton := SpecGui.AddButton("ys", "(Re)create spec")
    CreateSpecButton.OnEvent("Click", CreateSpecButton_Click)

    ; Config setup
    ConfigSetupButton := SpecGui.AddButton("ys", "Config setup")
    ConfigSetupButton.OnEvent("Click", ConfigSetupButton_Click)

    SpecGui.AddText("XM", ReOpenMessage ": To open this menu again for spec switching.")
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

CreateSpecButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    Run("ClassSetup.ahk")
}

ConfigSetupButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    Run("ConfigSetup.ahk")
}