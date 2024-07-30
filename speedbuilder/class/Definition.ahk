Class Definition {
    Name := ""
    IconID := 0
    Alias := ""
    DefinitionType := "Spell"

    __New(DefinitionString, DefinitionType) {
        Values := StrSplit(DefinitionString, ",")

        this.Name := Values[1]
        this.IconID := Values[2]
        if Values.Length >= 3
            this.Alias := Values[3]

        this.DefinitionType := DefinitionType
    }
}
