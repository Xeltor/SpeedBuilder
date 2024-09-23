showPopup(Message) {
    x := A_ScreenWidth - ( 5 * StrLen(Message) )
    y := A_ScreenHeight

    ToolTip("`n" Message "`n ", x, y)
    ; Hide the tooltip after 5 seconds
    SetTimer(() => ToolTip(""), -5000)
}

GetProfileNames(Setup := false) {
    Profiles := []
    DirLocation := Setup ? "speedbuilder\definitions\*.txt" : "Keybinds\*.txt"

    loop files DirLocation {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)
            Spec := Profile(FileWithoutExt,,false)

            Profiles.Push(Spec.Name)
        }
    }

    return Profiles
}

GetProfiles() {
    Profiles := []
    DirLocation := "Keybinds\*.txt"

    loop files DirLocation {
        FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)
        Spec := Profile(FileWithoutExt)

        Profiles.Push(Spec)
    }

    return Profiles
}

ClearCache() {
    try {
        if FileExist("Cache/cache.ini")
            FileDelete("Cache/cache.ini")
        return true
    }
    return false
}
