#include ../includes/ColorPicker.ahk
#Include ../includes/ClassSetup.ahk
; Store globally so we can destroy it indirectly.
global IconReplacementGui := ""
global SetupData := Object()

#HotIf IconReplacementGui != "" and WinActive(Warcraft)
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

IconReplacementSelection(ClassSpecChoice) {
    global IconReplacementGui
    global SetupData

    SetupData.ClassSpecChoice := ClassSpecChoice

    IconReplacementGui := Gui("+AlwaysOnTop +ToolWindow", AppName)
    IconReplacementGui.AddText("Section", "Icon replacement setup. (Don't close this window)")
    IconReplacementGui.AddText("", "- Open Hekili. (/hekili)`n- Go to Abilities in the left side row.`n- In the top right select the ability Hekili is showing.`n- CTRL + Click inside the Icon Replacement box.")
    IconReplacementGui.OnEvent("Close", IconReplacementGui_Close)

    IconReplacementGui.Show()
}

IconReplacementGui_Close(GuiCtrlObj) {
    ExitApp()
}