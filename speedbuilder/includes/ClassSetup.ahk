#Include ColorPicker.ahk
#Include Helpers.ahk

AutomaticClassSetup(xCoord, yCoord, RedoAllIcons) {
    ; Get color combo for each icon.
    TotalItems := LoadedSpec.Actions.Length
    i := 1
    for Act in LoadedSpec.Actions {
        if Act.IsUpdated or RedoAllIcons {
            showPopup("Progress: " i "/" TotalItems)
            SetIconReplacement(Act.IconID, xCoord, yCoord)
            Act.Colors := GetPixelColors(true)
        }
        i++
    }
    ResetIconReplacement(xCoord, yCoord)

    ; Save and notify user that the process has completed.
    if LoadedSpec.SaveActions() {
        ; Reload without setup data.
        LoadedSpec := Specialization(LoadedSpec.FileName)

        if MsgBox("The automatic process has completed.`n`nDo you want to open the keybind menu to setup/update your keybinds?", AppName, "0x44") = "Yes" {
            ; Open keybinds tool.
            KeybindList()
            return
        }
    }
    
    ; Return to main menu on completion.
    SpecSelectionGui()
}
