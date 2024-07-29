#Include ..\includes\SpellBook.ahk

SpecSelection(Config) {
    ClassSpecs := GetClassSpecs()
    
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
    SpecGui.AddDropDownList("vClassSpecChoice r10 w400", ClassSpecs)

    ; Load spec
    LoadButton := SpecGui.AddButton("Default Section", "(Re)load spec/keybinds")
    LoadButton.OnEvent("Click", LoadButton_Click)

    ; (Re)create spec
    CreateSpecButton := SpecGui.AddButton("ys", "(Re)create spec")
    CreateSpecButton.OnEvent("Click", CreateSpecButton_Click)

    ; Config setup
    ConfigSetupButton := SpecGui.AddButton("ys", "Config setup")
    ConfigSetupButton.OnEvent("Click", ConfigSetupButton_Click)

    SpecGui.AddText("XM", ReOpenMessage ": To open this menu again.")
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
        MsgBox("No class spec selected, please select a class spec.", AppName, "0x30")
        SpecSelection(Config)
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

    ; Stop the rotation, if the user didnt already.
    if Toggle
        Send(Config.ToggleOnOffKeyBind)

    ; Run class spec setup.
    SpecSetupSelection()
}

ConfigSetupButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Run config setup.
    Run("speedbuilder\setup\ConfigSetup.ahk")

    ; Close, we need to restart to reload config.
    ExitApp()
}