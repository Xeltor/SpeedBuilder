SpecSelection() {
    ClassSpecs := GetClassSpecs()
    keybindLabels := Map(
        "\#", "WindowsKey + ", 
        "\!", "Alt + ", 
        "\^", "Ctrl + ", 
        "\+", "Shift + "
    )
    
    ReOpenMessage := ""
    TrimCount := 0

    ; Construct the re-open message based on the keybind configuration
    for key, label in keybindLabels {
        if (cfg.SpecSelectionKeyBind ~= key) {
            ReOpenMessage .= label
            TrimCount++
        }
    }

    ; Append the remaining part of the keybind
    ReOpenMessage .= (TrimCount ? SubStr(cfg.SpecSelectionKeyBind, TrimCount + 1) : cfg.SpecSelectionKeyBind)

    ; Create GUI
    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to play.")

    ; Populate list.
    ClassSpecChoice := SpecGui.AddDropDownList("vClassSpecChoice r10 w400", ClassSpecs)
    try {
        ; Attempt to select the current spec if set.
        ClassSpecChoice.Choose(LoadedSpec.Name)
    }

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
    global LoadedSpec
    
    ; Hide parent.
    SpecSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ClassSpecChoice := SpecSelectorValues.ClassSpecChoice,

    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    if !ClassSpecChoice {
        MsgBox("No class spec selected, please select a class spec.", AppName, "0x30")
        SpecSelection()
        return
    }

    LoadedSpec := Specialization(ClassSpecChoice)

    ClassSpec := LoadedSpec.Name
    showPopup("Loaded " LoadedSpec.Actions.Count " actions for " ClassSpec)

    if not WinActive(cfg.Warcraft) and WinExist(cfg.Warcraft)
        WinActivate(cfg.Warcraft)
}

SpecSelectGui_Close(GuiCtrlObj) {
    ExitApp()
}

CreateSpecButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Stop the rotation, if the user didnt already.
    if cfg.ToggleState
        ToggleSpeedBuilder("")

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
