#Include IconReplacementSetup.ahk

ProfileGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
ProfileGui.SetFont("s11")
ProfileGui.AddText(,"Please select the profile you wish to setup.")
ProfileGui.OnEvent("Close", ProfileGui_Close)

; Dropdown menu
ProfileGui_Dropdown := ProfileGui.AddDropDownList("vProfileChoice r10 w360")
ProfileGui_Dropdown.OnEvent("Change", ProfileGui_Dropdown_Change)

; Continue button
ProfileGui_ContinueButton := ProfileGui.AddButton("Default Section Disabled", "Continue")
ProfileGui_ContinueButton.OnEvent("Click", ProfileGui_ContinueButton_Click)

; Force button
ProfileGui_ForceButton := ProfileGui.AddButton("ys Disabled", "Force*")
ProfileGui_ForceButton.OnEvent("Click", ProfileGui_ForceButton_Click)

; Cancel button
ProfileGui_CancelButton := ProfileGui.AddButton("ys", "Cancel")
ProfileGui_CancelButton.OnEvent("Click", ProfileGui_CancelButton_Click)

; Warning
ProfileGui.AddText("xs","*Force: Forces HACK to check all action colors, skipping cache.")

ProfileSetupGui(ProfileChoice := "") {
    Profiles := GetProfileNames(true)

    ProfileGui_Dropdown.Add(Profiles)
    if ProfileChoice
        ProfileGui_Dropdown.Choose(ProfileChoice)

    if ProfileGui_Dropdown.Value {
        ProfileGui_ContinueButton.Enabled := true
        ProfileGui_ForceButton.Enabled := true
    } else {
        ProfileGui_ContinueButton.Enabled := false
        ProfileGui_ForceButton.Enabled := false
    }

    ProfileGui.Show()
}

ProfileGui_Dropdown_Change(GuiCtrlObj, Info) {
    if GuiCtrlObj.Value {
        ProfileGui_ContinueButton.Enabled := true
        ProfileGui_ForceButton.Enabled := true
    } else {
        ProfileGui_ContinueButton.Enabled := false
        ProfileGui_ForceButton.Enabled := false
    }
}

ProfileGui_ContinueButton_Click(GuiCtrlObj, Info) {
    global ActiveProfile

    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice

    ; Load profile setup.
    ActiveProfile := Profile(ProfileChoice, true)

    ; Icon replacement GUI.
    IconReplacementSelectionGui("Setup")
}

ProfileGui_ForceButton_Click(GuiCtrlObj, Info) {
    global ActiveProfile

    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice

    ; Load profile setup.
    ActiveProfile := Profile(ProfileChoice, true)

    ; Icon replacement GUI.
    IconReplacementSelectionGui("Setup")
}

ProfileGui_CancelButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Hide()

    ; Go back to the main menu.
    MainWindow()
}

; Go back to the main menu.
ProfileGui_Close(GuiCtrlObj) => MainWindow()
