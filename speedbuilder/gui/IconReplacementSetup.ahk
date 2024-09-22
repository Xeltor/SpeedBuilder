#include ../includes/ColorPicker.ahk
#Include ../includes/ClassSetup.ahk
; Store globally so we can destroy it indirectly.
global IconReplacementGui := ""

#HotIf IconReplacementGui != "" and WinActive(cfg.Warcraft)
CTRL & LButton:: {
    global IconReplacementGui

    MouseGetPos(&xCoord, &yCoord)
    SetIconReplacement(666, xCoord, yCoord)

    if GetPixelColors(true) = "0x00FF000x00FF00" {
        ResetIconReplacement(xCoord, yCoord)

        IconReplacementGui.Destroy()
        IconReplacementGui := ""

        AutomaticClassSetup(xCoord, yCoord)
    } else {
        ResetIconReplacement(xCoord, yCoord)
        MsgBox("Could not find the Icon Replacement box, please try again or escape to cancel.", AppName, "0x30")
    }
}
#HotIf

IconReplacementSelectionGUi() {
    global IconReplacementGui

    IconReplacementGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    IconReplacementGui.SetFont("s11")
    IconReplacementGui.AddText("Section", "Icon replacement setup. (Don't close this window)")
    IconReplacementGui.AddText("", "1. Open Hekili. ( /hekili )`n2. Make the primary box visible. (Displays -> Primary -> Visibility)`n3. Go to Abilities in the left side row.`n4. In the top right select the ability Hekili is showing.`n5. CTRL + Click inside the Icon Replacement box.")
    IconReplacementGui.OnEvent("Close", IconReplacementGui_Close)

    IconReplacementGui.Show("X0 Y0")

    ; Activate WoW if it exists.
    if !WinActive(cfg.Warcraft) and WinExist(cfg.Warcraft)
        WinActivate(cfg.Warcraft)
}

IconReplacementGui_Close(GuiCtrlObj) => SpecSetupSelectionGui()
