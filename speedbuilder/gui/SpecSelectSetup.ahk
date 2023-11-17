#Include ..\includes\SpellBook.ahk
#Include IconReplacementSetup.ahk

SpecSetupSelection() {
    ClassSpecs := GetClassSpecs(true)

    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to setup/update*.")
    SpecGui.AddDropDownList("vClassSpecChoice r10 w360", ClassSpecs)
    ContinueButton := SpecGui.AddButton("Default", "Continue")
    ContinueButton.OnEvent("Click", ContinueButton_Click)
    SpecGui.AddText("Section","* This process will never overwrite any previously set keybinds.")
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

    if !ClassSpecChoice {
        MsgBox("No class spec selected, exiting.", AppName, "0x30")
        ExitApp()
    }

    ; Icon replacement GUI.
    IconReplacementSelection(ClassSpecChoice)
}

SpecGui_Close(GuiCtrlObj) {
    ExitApp()
}