#Include ../class/Battlenet.ahk

SpecSelectionGui() {
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

    ; Generate tabs
    Tab := SpecGui.Add("Tab3",, ["Run", "Config"])
    Tab.UseTab(1)
    SpecGui.AddText("Section","Please select the class spec you wish to play.")

    ; Populate list.
    ClassSpecChoice := SpecGui.AddDropDownList("vClassSpecChoice r10 w400", ClassSpecs)
    try {
        ; Attempt to select the current spec if set.
        ClassSpecChoice.Choose(LoadedSpec.Name)
    }

    ; Load spec
    LoadButton := SpecGui.AddButton("Default", "(Re)load")
    LoadButton.OnEvent("Click", LoadButton_Click)

    ; Check if WoW is running
    bnet := Battlenet()
    if !WinExist(cfg.Warcraft) and bnet.Exists() {
        LaunchButton := SpecGui.AddButton("yp", "Launch WoW")
        LaunchButton.OnEvent("Click", LaunchButton_Click)
    }

    SpecGui.AddText("XS", ReOpenMessage ": To open this menu again.")
    SpecGui.OnEvent("Close", SpecSelectGui_Close)

    ; Continue in Tab 2 Config
    Tab.UseTab(2)

    SpecGui.AddGroupBox("r4 Section", "Keybinds")

    SpecGui.AddText("XP+10 YP+20 W175 R3", "Change your current selected spec's keybinds.")

    OpenKeybindsButton := SpecGui.AddButton("", "Change keybinds")
    OpenKeybindsButton.OnEvent("Click", OpenKeybindsButton_Click)

    SpecGui.AddGroupBox("r4 YS", "Setup")
    
    ; (Re)create spec
    CreateSpecButton := SpecGui.AddButton("XP+10 YP+25", "(Re)create spec")
    CreateSpecButton.OnEvent("Click", CreateSpecButton_Click)

    ; Config setup
    ConfigSetupButton := SpecGui.AddButton("YP+50", "Config setup")
    ConfigSetupButton.OnEvent("Click", ConfigSetupButton_Click)

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
        SpecSelectionGui()
        return
    }

    LoadedSpec := Specialization(ClassSpecChoice)

    ClassSpec := LoadedSpec.Name
    showPopup("Loaded " LoadedSpec.Actions.Count " actions for " ClassSpec)

    if not WinActive(cfg.Warcraft) and WinExist(cfg.Warcraft)
        WinActivate(cfg.Warcraft)
}

LaunchButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Launch WoW
    bnet := Battlenet()
    bnet.LaunchWoW()

    ; Wait for it
    showPopup("Waiting up to 30 seconds for WoW to appear.")
    WinWait(cfg.Warcraft,,30)

    ; Open GUI again.
    SpecSelectionGui()
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
    SpecSetupSelectionGui()
}

ConfigSetupButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Run config setup.
    Run("speedbuilder\setup\ConfigSetup.ahk")

    ; Close, we need to restart to reload config.
    ExitApp()
}

OpenKeybindsButton_Click(GuiCtrlObj, Info) {
    global LoadedSpec
    
    ; Hide parent.
    SpecSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ClassSpecChoice := SpecSelectorValues.ClassSpecChoice,

    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    if !ClassSpecChoice {
        MsgBox("No class spec selected, please select a class spec.", AppName, "0x30")
        SpecSelectionGui()
        return
    }

    LoadedSpec := Specialization(ClassSpecChoice)

    KeybindList()
}
