#include ../includes/ColorPicker.ahk
#Include ../includes/ClassSetup.ahk
; Store globally so we can destroy it indirectly.
global IconReplacementGui := ""
global SetupData := Object()

#HotIf IconReplacementGui != "" and WinActive(cfg.Warcraft)
CTRL & LButton:: {
    global IconReplacementGui
    global SetupData

    MouseGetPos(&xCoord, &yCoord)
    SetIconReplacement(666, xCoord, yCoord)

    if GetPixelColors(true) = "0x00FF000x00FF00" {
        SetupData.xCoord := xCoord
        SetupData.yCoord := yCoord

        ResetIconReplacement(xCoord, yCoord)

        IconReplacementGui.Destroy()
        IconReplacementGui := ""

        RedoAllIcons := false
        if MsgBox("Would you like to redo all icon colors?", AppName, "0x124") = "Yes" {
            RedoAllIcons := true
        }

        MsgBox("The manual part of the setup is completed. After pressing OK please don't use the keyboard and mouse while automatic setup works.`n`nYou will be notified when the process has completed.", AppName, "0x20")

        AutomaticClassSetup(SetupData, RedoAllIcons)
    } else {
        MsgBox("Could not find the Icon Replacement box, please try again or escape to cancel.", AppName, "0x30")
    }
}
#HotIf

IconReplacementSelectionGUi(ClassSpecChoice) {
    global IconReplacementGui
    global SetupData

    SetupData.ClassSpecChoice := ClassSpecChoice

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
