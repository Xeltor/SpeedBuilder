showPopup(Message) {
    x := A_ScreenWidth - ( 5 * StrLen(Message) )
    y := A_ScreenHeight

    ToolTip("`n" Message "`n ", x, y)
    ; Hide the tooltip after 5 seconds
    SetTimer(() => ToolTip(""), -5000)
}

GetClassSpecs(Setup := false) {
    ClassSpecs := []

    DirLocation := Setup ? "speedbuilder\definitions\*.txt" : "Keybinds\*.txt"

    loop files DirLocation {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)

            ClassSpecs.Push(Specialization(FileWithoutExt).Name)
        }
    }

    return ClassSpecs
}
