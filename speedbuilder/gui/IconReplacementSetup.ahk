#include ../includes/ColorPicker.ahk
#Include ../includes/ClassSetup.ahk

global IconReplacementGui_Callback := ""

IconReplacementGui := Gui("+AlwaysOnTop +ToolWindow", "HACK: Icon replacement setup")
IconReplacementGui.SetFont("s11")
IconReplacementGui.AddText("Section", "Icon replacement setup. (Don't close this window)")
IconReplacementGui.AddText("", "1. Open Hekili. ( /hek )`n2. Make the primary box visible. (Displays -> Primary -> Visibility)`n3. Go to Abilities in the left side row.`n4. In the top right select the ability Hekili is showing.`n5. CTRL + Click inside the Icon Replacement box.")
IconReplacementGui.OnEvent("Close", IconReplacementGui_Close)

#HotIf WinExist("HACK: Icon replacement setup")
CTRL & LButton:: {
    MouseGetPos(&xCoord, &yCoord)
    SetIconReplacement(666, xCoord, yCoord)

    if GetPixelColors(true) = "0x00FF000x00FF00" {
        ResetIconReplacement(xCoord, yCoord)

        IconReplacementGui.Hide()

        AutomaticClassSetup(xCoord, yCoord)
    } else {
        ResetIconReplacement(xCoord, yCoord)
        MsgBox("Could not find the Icon Replacement box, please try again or escape to cancel.", AppName, "0x30")
    }
}
#HotIf

IconReplacementSelectionGUi(Callback := "") {
    global IconReplacementGui_Callback := Callback
    IconReplacementGui.Show("X0 Y0")

    ; Activate WoW if it exists.
    if !WinActive(cfg.Warcraft) and WinExist(cfg.Warcraft)
        WinActivate(cfg.Warcraft)
}

IconReplacementGui_Close(GuiCtrlObj) {
    switch IconReplacementGui_Callback {
        case "Main":
            MainWindow()
        case "Setup":
            ProfileSetupGui()
        default:
            return
    }
}
