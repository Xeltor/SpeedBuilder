#Include ../class/Battlenet.ahk

; Create GUI
MainGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
MainGui.SetFont("s11")

; Add tabs
MainGui_Tab := MainGui.Add("Tab3",, ["Profile", "Config"])
MainGui_Tab.UseTab(1)

; Generate tabs
MainGui.AddText("Section","Please select the profile you wish to play.")

; Populate list.
MainGui_ProfileChoice := MainGui.AddDropDownList("vProfileChoice r10 w400")
MainGui_ProfileChoice.OnEvent("Change", ProfileChoice_Change)

; Load button
MainGui_LoadButton := MainGui.AddButton("Default", "(Re)load")
MainGui_LoadButton.OnEvent("Click", LoadButton_Click)

; Profile keybinds
MainGui_OpenKeybindsButton := MainGui.AddButton("yp Disabled", "Keybinds")
MainGui_OpenKeybindsButton.OnEvent("Click", OpenKeybindsButton_Click)

; Create profile
MainGui_CreateProfileButton := MainGui.AddButton("xp+123", "Create")
MainGui_CreateProfileButton.OnEvent("Click", CreateProfileButton_Click)

; Update profile
MainGui_UpdateProfileButton := MainGui.AddButton("yp Disabled", "Update")
MainGui_UpdateProfileButton.OnEvent("Click", UpdateProfileButton_Click)

; Delete profile
MainGui_DeleteProfileButton := MainGui.AddButton("yp Disabled", "Delete")
MainGui_DeleteProfileButton.OnEvent("Click", DeleteProfileButton_Click)

; Re-open text
MainGui_ReopenText := MainGui.AddText("XS w400", "")
MainGui.OnEvent("Close", ProfileSetupSelectGui_Close)

; Continue in Tab 2 Config
MainGui_Tab.UseTab(2)

; Generate cache
MainGui.AddGroupBox("r4 Section", "Cache")
MainGui.AddText("XP+10 YP+20 W175 R3", "Generate icon cache from existing profiles to speed up profile creation.")
MainGui_GenerateCacheButton := MainGui.AddButton("xp", "Generate")
MainGui_GenerateCacheButton.OnEvent("Click", GenerateCacheButton_Click)
MainGui_GenerateCacheButton := MainGui.AddButton("yp", "Clear")
MainGui_GenerateCacheButton.OnEvent("Click", ClearCacheButton_Click)

; Config setup
MainGui.AddGroupBox("r4 YS", "Hekili")
MainGui.AddText("XP+10 YP+20 W175 R3", "Update Hekili related config settings.")
MainGui_ConfigSetupButton := MainGui.AddButton("xp yp+56", "Hekili setup")
MainGui_ConfigSetupButton.OnEvent("Click", ConfigSetupButton_Click)

MainWindow() {
    ; Add profiles.
    Profiles := GetProfileNames()
    MainGui_ProfileChoice.Delete()
    MainGui_ProfileChoice.Add(Profiles)

    ; Attempt to select the current profile if set.
    try {
        MainGui_ProfileChoice.Choose(ActiveProfile.Name)
    }
    Toggle_Buttons((ActiveProfile) ? ActiveProfile.Name : "")
    
    ; Construct the re-open message based on the keybind configuration
    keybindLabels := Map(
        "\#", "WindowsKey + ", 
        "\!", "Alt + ", 
        "\^", "Ctrl + ", 
        "\+", "Shift + "
    )

    ReOpenMessage := ""
    TrimCount := 0

    for key, label in keybindLabels {
        if (cfg.MainWindowKeybind ~= key) {
            ReOpenMessage .= label
            TrimCount++
        }
    }

    ; Append the remaining part of the keybind
    ReOpenMessage .= (TrimCount ? SubStr(cfg.MainWindowKeybind, TrimCount + 1) : cfg.MainWindowKeybind)
    MainGui_ReopenText.Text := ReOpenMessage ": To open this menu again."

    MainGui.Show()
}

ProfileChoice_Change(GuiCtrlObj, Info) {
    Toggle_Buttons(GuiCtrlObj.Value)
}

Toggle_Buttons(State) {
    if State {
        MainGui_OpenKeybindsButton.Enabled := true
        MainGui_UpdateProfileButton.Enabled := true
        MainGui_DeleteProfileButton.Enabled := true
    } else {
        MainGui_OpenKeybindsButton.Enabled := false
        MainGui_UpdateProfileButton.Enabled := false
        MainGui_DeleteProfileButton.Enabled := false
    }
}

LoadButton_Click(GuiCtrlObj, Info) {
    global ActiveProfile
    
    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice

    ; Destroy gui.
    GuiCtrlObj.Gui.Hide()

    if !ProfileChoice {
        MsgBox("No profile selected, please select a profile.", AppName, "0x30")
        MainWindow()
        return
    }

    ActiveProfile := Profile(ProfileChoice)

    if ActiveProfile.HasUpdates and MsgBox(ActiveProfile.Name " has " ActiveProfile.UpdateCount " updates. Would you like to update the profile now?", AppName, "0x124") = "Yes" {
        ; Return if warcraft isnt running.
        if !WinExist(cfg.Warcraft) {
            MsgBox("Please make sure World of Warcraft is running.", AppName, "0x30")
            MainWindow()
            return
        }

        ; Load profile setup.
        ActiveProfile := Profile(ProfileChoice, true)

        ; Icon replacement GUI.
        IconReplacementSelectionGui("Main")
    } else {
        showPopup("Loaded " ActiveProfile.Actions.Count " actions for " ActiveProfile.Name)
    
        if not WinActive(cfg.Warcraft) and WinExist(cfg.Warcraft)
            WinActivate(cfg.Warcraft)
    }
}

ProfileSetupSelectGui_Close(GuiCtrlObj) {
    ; Inform user.
    showPopup("Minimized HACK to tray.")
    return
}

CreateProfileButton_Click(GuiCtrlObj, Info) {
    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice

    ; Stop the rotation, if the user didnt already.
    if cfg.ToggleState
        ToggleSpeedBuilder("")

    ; Run profile setup.
    ProfileSetupGui((ProfileChoice) ? ProfileChoice : "")
}

UpdateProfileButton_Click(GuiCtrlObj, Info) {
    global ActiveProfile
    
    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice

    ; Load profile setup.
    ActiveProfile := Profile(ProfileChoice, true)

    ; Stop the rotation, if the user didnt already.
    if cfg.ToggleState
        ToggleSpeedBuilder("")

    ; Icon replacement GUI.
    IconReplacementSelectionGui("Main")
}

DeleteProfileButton_Click(GuiCtrlObj, Info) {
    global ActiveProfile

    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice

    if MsgBox("Deleting a profile can not be reversed!`n`nAre you sure you wish to delete " ProfileChoice "?", AppName, "0x134") = "No" {
        MainGui.Show()
        return
    }

    ; Stop the rotation, if the user didnt already.
    if cfg.ToggleState
        ToggleSpeedBuilder("")

    Profile(ProfileChoice).Delete()
    MainGui_ProfileChoice.Delete(MainGui_ProfileChoice.Value)
    ActiveProfile := ""

    Toggle_Buttons("")

    MainGui.Show()
}

GenerateCacheButton_Click(GuiCtrlObj, Info) {
    if MsgBox("Generating cache can take a few seconds to minutes depending on how many profiles you have setup`n`ncontinue?", AppName, "0x1034") = "No" {
        return
    }

    ; Destroy gui.
    GuiCtrlObj.Gui.Hide()

    ; Get profiles.
    Profiles := GetProfiles()

    ; Generate icon color cache.
    for p in Profiles {
        p.GenerateCache()
    }

    showPopup("Icon color cache generation complete.")

    ; Open profile selection again.
    MainWindow()
}

ClearCacheButton_Click(GuiCtrlObj, Info) {
    ClearCache()
    showPopup("Icon color cache cleared.")
}

ConfigSetupButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Hide()

    ; Run config setup.
    Run("speedbuilder\setup\ConfigSetup.ahk")

    ; Close, we need to restart to reload config.
    ExitApp()
}

OpenKeybindsButton_Click(GuiCtrlObj, Info) {
    global ActiveProfile

    ; Hide parent.
    ProfileSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ProfileChoice := ProfileSelectorValues.ProfileChoice,

    ; Destroy gui.
    GuiCtrlObj.Gui.Hide()

    if !ProfileChoice {
        MsgBox("No profile selected, please select a profile", AppName, "0x30")
        MainWindow()
        return
    }

    ActiveProfile := Profile(ProfileChoice)

    KeybindList()
}
