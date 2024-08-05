Class Definition {
    Name := ""
    IconID := 0
    Alias := ""
    DefinitionType := "None"

    __New(DefinitionString, DefinitionType) {
        Values := StrSplit(DefinitionString, ",")
        this.Name := Values[1]
        this.IconID := Values[2]
        this.Alias := (Values.Length >= 3) ? Values[3] : this.Alias
        this.DefinitionType := DefinitionType
    }
}
