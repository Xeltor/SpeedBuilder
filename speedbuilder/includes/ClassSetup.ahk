#Include ColorPicker.ahk
#Include Helpers.ahk

AutomaticClassSetup(xCoord, yCoord, RedoAllIcons) {
    global LoadedSpec

    ; Get color combo for each icon.
    TotalItems := LoadedSpec.Actions.Count
    i := 1
    for _, Act in LoadedSpec.Actions {
        if (Act.IsUpdated and Act.GetCache() = "") or RedoAllIcons {
            showPopup("Progress: " i "/" TotalItems)
            SetIconReplacement(Act.IconID, xCoord, yCoord)
            Act.Colors := GetPixelColors(true)
            Act.WriteCache()
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
