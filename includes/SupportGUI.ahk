; Show help.
#HotIf TargetGui != ""
F1:: {
    global SupportGui

    if (SupportGui = "") {
        SupportGui := DrawSupportGui()
    } else {
        SupportGui.Destroy()
        SupportGui := ""
    }
}
#HotIf

DrawSupportGui() {
    SupportGui := Gui("+E0x20 +Resize +ToolWindow +ToolWindow +AlwaysOnTop -Caption")
    SupportGui.AddText(,"Make the crosshair fit the Hekili box as best as possible.`n`nControls:`nF1: Show/hide this help.`nLeft click: Moves crosshair to cursor.`nArrow keys: Moves crosshair 1 pixel in that direction.`nNumpad +/-: Increase or Decrease crosshair size.`nEscape: Save config and exit.")
    SupportGui.Show("x0 y0")

    return SupportGui
}
