GetSpellbooks() {
    Spellbooks := []

    loop files "specs\*.txt" {
        if not InStr(A_LoopFileName, "common_") {
            FileWithoutExt := StrReplace(A_LoopFileName, "." A_LoopFileExt)

            Spellbooks.Push(FileWithoutExt)
        }
    }

    return Spellbooks
}

GetSpells(Spellbook) {
    return
}