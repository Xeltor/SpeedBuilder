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
            Spec := Specialization(FileWithoutExt)

            ClassSpecs.Push(Spec.Name)
        }
    }

    return ClassSpecs
}

; Function to sort a Map by its keys
SortActionsByName(originalActions) {
    ; Create a string from the original map
    valString := ""
    for _, val in originalActions {
        valString .= val.Name ","
    }

    ; Sort string by comma
    sortedKeyString := Sort(valString, "D,")

    ; Split into a sorted array
    sortedArray := StrSplit(sortedKeyString, ",")

    ; Create a new sorted Map
    sortedActions := []
    for _, val in sortedArray {
        if val != "" {
            result := FindObjectByParameter(originalActions, val)
            if result
                sortedActions.Push(result)
        }
    }

    return sortedActions
}

FindObjectByParameter(originalActions, parameterValue) {
    for _, obj in originalActions {
        if (obj.Name = parameterValue) {
            return obj
        }
    }
    return ""  ; Return an empty string if no object is found
}