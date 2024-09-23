#Include ColorPicker.ahk
#Include Helpers.ahk

AutomaticClassSetup(xCoord, yCoord) {
    global ActiveProfile

    ; Find an existing icon color that doesnt need updating and check if its different.
    RedoAllIcons := false
    for _, Act in ActiveProfile.Actions {
        if Act.Colors != "" and !Act.IsUpdated {
            showPopup("Checking if redo is needed.")
            SetIconReplacement(Act.IconID, xCoord, yCoord)
            if Act.Colors != GetPixelColors(true) {
                if MsgBox("Action color mismatch detected on an existing action.`n`nIt is recommended to redo all icons, proceed?", AppName, "0x34") = "Yes" {
                    RedoAllIcons := true
                }
            }
            break
        }
    }
    ResetIconReplacement(xCoord, yCoord)

    MsgBox("The manual part of the setup is completed. After pressing OK please don't use the keyboard and mouse while automatic setup works.`n`nYou will be notified when the process has completed.", AppName, "0x20")

    ; Get color combo for each icon.
    TotalItems := ActiveProfile.Actions.Count
    i := 1
    for _, Act in ActiveProfile.Actions {
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
    if ActiveProfile.SaveActions() {
        ; Reload without setup data.
        ActiveProfile := Profile(ActiveProfile.FileName)

        if MsgBox("The automatic process has completed.`n`nDo you want to open the keybind menu to setup/update your keybinds?", AppName, "0x44") = "Yes" {
            ; Open keybinds tool.
            KeybindList()
            return
        }
    }
    
    ; Return to main window on completion.
    MainWindow()
}
