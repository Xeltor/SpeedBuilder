#Include HekiliSetupControls.ahk

; HEKILI SETUP GUI
HekiliSetup := Gui("+E0x20 +ToolWindow +AlwaysOnTop -Caption", "HACK: Hekili setup")
HekiliSetup.SetFont("s11")
HekiliSetup.OnEvent("Close", HekiliSetup_Close)

; Instruction
HekiliSetup.AddText("Section","Make the crosshair fit inside the Hekili box as best as possible.")
HekiliSetup.AddText(,"Controls:`nF1: Show/hide this help.`nCtrl + Left click: Moves crosshair to cursor.`nArrow keys: Moves crosshair 1 pixel in that direction.`nNumpad +/-: Increase or Decrease crosshair size.`n")

; Save
HekiliSetup_SaveButton := HekiliSetup.AddButton("Section", "Save")
HekiliSetup_SaveButton.OnEvent("Click", HekiliSetup_SaveButton_Click)

; Close
HekiliSetup_CloseButton := HekiliSetup.AddButton("ys", "Close")
HekiliSetup_CloseButton.OnEvent("Click", HekiliSetup_CloseButton_Click)

; TARGET CROSSHAIR GUI
HekiliTarget := Gui("+E0x20 +ToolWindow +LastFound +AlwaysOnTop")
HekiliTarget_Picture := HekiliTarget.AddPicture(, "speedbuilder/resources/bullseye.gif")
WinSetTransColor("0xFF00FF", HekiliTarget)
HekiliTarget.Opt("-Caption +Disabled")

HekiliSetupGui() {
    HekiliSetup.Show("y0 x0")
    HekiliTarget_Draw()
}

HekiliTarget_Draw() {
    HekiliTarget_Picture.Move(-0, -0, cfg.HekiliBoxWidth, cfg.HekiliBoxWidth)
    HekiliTarget.Show("x" (cfg.HekiliXCoord - (cfg.HekiliBoxWidth / 2)) " y" (cfg.HekiliYCoord - (cfg.HekiliBoxWidth / 2)) " w" cfg.HekiliBoxWidth " h" cfg.HekiliBoxWidth)
}

HekiliSetup_SaveButton_Click(GuiCtrlObj, Info) {
    ; Close instruction
    GuiCtrlObj.Gui.Hide()

    ; Close target interface
    HekiliTarget.Hide()

    ; Save
    cfg.Save()

    ; Go home your drunk
    MainWindow()
}

HekiliSetup_CloseButton_Click(GuiCtrlObj, Info) {
    ; Close instruction
    GuiCtrlObj.Gui.Hide()

    ; Close target interface
    HekiliTarget.Hide()

    ; Reset
    cfg.Load()

    ; Go home your drunk
    MainWindow()
}

HekiliSetup_Close(GuiCtrlObj) => MainWindow()