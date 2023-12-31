#Include ..\includes\SpellBook.ahk

SpecSelection() {
    ClassSpecs := GetClassSpecs()

    if !ClassSpecs.Length {
        MsgBox("No classes have been setup, please run ClassSetup.ahk", AppName)
        ExitApp()
    }

    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to play.")
    SpecGui.AddDropDownList("vClassSpecChoice r10 w360", ClassSpecs)
    LoadButton := SpecGui.AddButton("Default", "Load")
    LoadButton.OnEvent("Click", LoadButton_Click)
    SpecGui.AddText(,"WindowsKey + F12: To open this menu again for spec switching.")
    SpecGui.OnEvent("Close", SpecSelectGui_Close)

    SpecGui.Show()
}

LoadButton_Click(GuiCtrlObj, Info) {
    global SelectedClassSpec
    global KeyBinds

    ; Hide parent.
    SpecSelectorValues := GuiCtrlObj.Gui.Submit(true)

    ; Store choices.
    ClassSpecChoice := SpecSelectorValues.ClassSpecChoice

    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    if !ClassSpecChoice {
        MsgBox("No class spec selected, exiting.", AppName)
        ExitApp()
    }

    SelectedClassSpec := ClassSpecChoice
    KeyBinds := GetClassKeybinds(SelectedClassSpec, Map())
}

SpecSelectGui_Close(GuiCtrlObj) {
    ExitApp()
}