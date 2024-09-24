#SingleInstance Force
#Requires AutoHotkey v2
global AppName := "HACK: Hekili Automation and Control Kit"
#Include speedbuilder\class\Config.ahk
#Include speedbuilder\class\Profile.ahk
#Include speedbuilder\class\IconImage.ahk
#Include speedbuilder\includes\ColorPicker.ahk
#Include speedbuilder\includes\Helpers.ahk
CoordMode('ToolTip', 'Screen')
global cfg := Config()
global ActiveProfile := ""

GetAllActionIcons() {
    Profiles := []
    DirLocation := "speedbuilder\definitions\*.txt"

    loop files DirLocation {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)
            Spec := Profile(FileWithoutExt,, false)

            Profiles.Push(Spec)
        }
    }

    IconsIds := []
    for p in Profiles {
        for _, d in p.GetDefinitions() {
            IconsIds.Push(d.IconID)
        }
    }

    return IconsIds
}

iconlist := GetAllActionIcons()
MsgBox(iconlist.Length)

for icon in iconlist {
    Img := IconImage(icon)

    if !Img.Cached()
        Img.Download(icon)
}