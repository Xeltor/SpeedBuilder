Class Definition {
    Name := ""
    IconID := 0
    Alias := ""

    __New(DefinitionString) {
        Values := StrSplit(DefinitionString, ",")
        this.Name := Values[1]
        this.IconID := Values[2]
        this.Alias := (Values.Length >= 3) ? Values[3] : this.Alias
    }
}
