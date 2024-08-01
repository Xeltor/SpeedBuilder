#Include IconReplacementSetup.ahk

SpecSetupSelection() {
    ; Stop if warcraft isnt running.
    if !WinExist(cfg.Warcraft) {
        MsgBox("Please make sure World of Warcraft is running and select (Re)create spec to try again.", AppName, "0x30")
        SpecSelection()
        return
    }

    ClassSpecs := GetSetupClassSpecs()

    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to setup/update*.")
    SpecGui.AddDropDownList("vClassSpecChoice r10 w360", ClassSpecs)
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

    if !ClassSpecChoice {
        MsgBox("No class spec selected, please select a spec.", AppName, "0x30")
        SpecSetupSelection()
    }

    ; Load specialization setup.
    ClassSpecSetup := Specialization(ClassSpecChoice).LoadSetup()

    ; Icon replacement GUI.
    IconReplacementSelection(ClassSpecSetup)
}

CancelButton_Click(GuiCtrlObj, Info) {
    ; Destroy gui.
    GuiCtrlObj.Gui.Destroy()

    ; Go back to the main menu.
    SpecSelection()
}

SpecGui_Close(GuiCtrlObj) {
    ; Go back to the main menu.
    SpecSelection()
}

GetSetupClassSpecs() {
    ClassSpecs := []

    DirLocation := "speedbuilder\definitions\*.txt"

    loop files DirLocation {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)

            ClassSpecs.Push(Specialization(FileWithoutExt).Name)
        }
    }

    return ClassSpecs
}