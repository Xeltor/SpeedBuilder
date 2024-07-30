#Include IconReplacementSetup.ahk

SpecSetupSelection() {
    ; Stop if warcraft isnt running.
    if !WinExist(cfg.Warcraft) {
        MsgBox("Please make sure World of Warcraft is running and select (Re)create spec to try again.", AppName, "0x30")
        SpecSelection()
        return
    }

    ClassSpecs := GetSetupClassSpecs()
    ClassSpecNames := []

    for spec in ClassSpecs {
        ClassSpecNames.Push(spec.Name)
    }

    SpecGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    SpecGui.SetFont("s11")
    SpecGui.AddText(,"Please select the class spec you wish to setup/update*.")
    SpecGui.AddDropDownList("vClassSpecChoice r10 w360", ClassSpecNames)
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
    ClassSpecChoice := StrLower(StrReplace(SpecSelectorValues.ClassSpecChoice, " ", "_"))

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

SpecGui_Close(GuiCtrlObj) {
    ExitApp()
}

GetSetupClassSpecs() {
    ClassSpecs := []

    DirLocation := "speedbuilder\definitions\*.txt"

    loop files DirLocation {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)

            ClassSpecs.Push(Specialization(FileWithoutExt))
        }
    }

    return ClassSpecs
}