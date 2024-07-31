SpecSelection() {
    ClassSpecs := GetClassSpecs()
    ClassSpecNames := []

    for spec in ClassSpecs {
        ClassSpecNames.Push(spec.Name)
    }
    
    ReOpenMessage := ""
    TrimCount := 0
    if (cfg.SpecSelectionKeyBind ~= "\#") {
        ReOpenMessage .= "WindowsKey + "
        TrimCount++
    }
    if (cfg.SpecSelectionKeyBind ~= "\!") {
        ReOpenMessage .= "Alt + "
        TrimCount++
    }
    if (cfg.SpecSelectionKeyBind ~= "\^") {
        ReOpenMessage .= "Ctrl + "
        TrimCount++
    }
    if (cfg.SpecSelectionKeyBind ~= "\+") {
        ReOpenMessage .= "Shift + "
        TrimCount++
    }
    if TrimCount {
        ReOpenMessage .= SubStr(cfg.SpecSelectionKeyBind, TrimCount + 1)
    } else {
        ReOpenMessage .= cfg.SpecSelectionKeyBind
    }

    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to play.")
    ClassSpecChoice := SpecGui.AddDropDownList("vClassSpecChoice r10 w400", ClassSpecNames)
    try {
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
    ClassSpecChoice := StrLower(StrReplace(SpecSelectorValues.ClassSpecChoice, " ", "_"))

    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    if !ClassSpecChoice {
        MsgBox("No class spec selected, please select a class spec.", AppName, "0x30")
        SpecSelection()
        return
    }

    LoadedSpec := Specialization(ClassSpecChoice).LoadActions()

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

GetClassSpecs() {
    ClassSpecs := []

    DirLocation := "Keybinds\*.txt"

    loop files DirLocation {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)

            ClassSpecs.Push(Specialization(FileWithoutExt))
        }
    }

    return ClassSpecs
}