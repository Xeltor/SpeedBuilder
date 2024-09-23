#Include IconReplacementSetup.ahk

ProfileSetupGui(ProfileChoice := "") {
    Profiles := GetProfileNames(true)

    ProfileGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    ProfileGui.SetFont("s11")
    ProfileGui.AddText(,"Please select the profile you wish to setup.")
    ProfileDropdown := ProfileGui.AddDropDownList("vProfileChoice r10 w360", Profiles)
    if ProfileChoice
        ProfileDropdown.Choose(ProfileChoice)
    ContinueButton := ProfileGui.AddButton("Default Section", "Continue")
    ContinueButton.OnEvent("Click", ContinueButton_Click)
    CancelButton := ProfileGui.AddButton("ys", "Cancel")
    CancelButton.OnEvent("Click", CancelButton_Click)
    ProfileGui.OnEvent("Close", ProfileGui_Close)

    ProfileGui.Show()
}

ContinueButton_Click(GuiCtrlObj, Info) {
    global ActiveProfile

    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice

    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Return if no profile is selected.
    if !ProfileChoice {
        MsgBox("No profile selected, please select a profile.", AppName, "0x30")
        ProfileSetupGui()
        return
    }

    ; Load profile setup.
    ActiveProfile := Profile(ProfileChoice, true)

    ; Icon replacement GUI.
    IconReplacementSelectionGui("Setup")
}

CancelButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Go back to the main menu.
    MainWindow()
}

; Go back to the main menu.
ProfileGui_Close(GuiCtrlObj) => MainWindow()
