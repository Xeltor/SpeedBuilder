#Include IconReplacementSetup.ahk

SpecSetupSelectionGui(ClassSpecChoice := "") {
    ClassSpecs := GetClassSpecs(true)

    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to setup/update*.")
    ClassSpecsDropdown := SpecGui.AddDropDownList("vClassSpecChoice r10 w360", ClassSpecs)
    if ClassSpecChoice
        ClassSpecsDropdown.Choose(ClassSpecChoice)
    ContinueButton := SpecGui.AddButton("Default Section", "Continue")
    ContinueButton.OnEvent("Click", ContinueButton_Click)
    CancelButton := SpecGui.AddButton("ys", "Cancel")
    CancelButton.OnEvent("Click", CancelButton_Click)
    SpecGui.AddText("XM","* This process will never overwrite any previously set keybinds.")
    SpecGui.OnEvent("Close", SpecGui_Close)

    SpecGui.Show()
}

ContinueButton_Click(GuiCtrlObj, Info) {
    ; Hide parent.
    SpecSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ClassSpecChoice := SpecSelectorValues.ClassSpecChoice

    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Return if warcraft isnt running.
    if !WinExist(cfg.Warcraft) {
        MsgBox("Please make sure World of Warcraft is running.", AppName, "0x30")
        SpecSetupSelectionGui(ClassSpecChoice)
        return
    }

    ; Return if no spec is selected.
    if !ClassSpecChoice {
        MsgBox("No class spec selected, please select a spec.", AppName, "0x30")
        SpecSetupSelectionGui()
        return
    }

    ; Load specialization setup.
    ClassSpecSetup := Specialization(ClassSpecChoice, true)

    ; Icon replacement GUI.
    IconReplacementSelectionGui(ClassSpecSetup)
}

CancelButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Go back to the main menu.
    SpecSelectionGui()
}

; Go back to the main menu.
SpecGui_Close(GuiCtrlObj) => SpecSelectionGui()
