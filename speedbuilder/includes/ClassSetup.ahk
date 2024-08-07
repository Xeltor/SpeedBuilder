#Include ColorPicker.ahk
#Include Helpers.ahk

AutomaticClassSetup(SetupData, RedoAllIcons) {
    global LoadedSpec

    ; Get existing actions.
    LoadedSpec := SetupData.ClassSpecChoice

    ; Update actions from definitions.
    ActionList := []
    for Definition in SetupData.ClassSpecChoice.Definitions {
        ; Update existing or generate from definition.
        UpdatedAction := LoadedSpec.Actions.Has(Definition.Name) ? LoadedSpec.Actions[Definition.Name].FromDefinition(Definition) : Action().FromDefinition(Definition)

        ActionList.Push(UpdatedAction)
    }

    ; Get color combo for each icon.
    TotalItems := ActionList.Length
    i := 1
    for Act in ActionList {
        if Act.IsUpdated or RedoAllIcons {
            showPopup("Progress: " i "/" TotalItems)
            SetIconReplacement(Act.IconID, SetupData.xCoord, SetupData.yCoord)
            Act.Colors := GetPixelColors(true)
        }
        i++
    }
    ResetIconReplacement(SetupData.xCoord, SetupData.yCoord)

    ; Set updated actions.
    LoadedSpec.Actions := ActionList

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
