Class Definition {
    Name := ""
    IconID := 0
    Alias := ""
    Delay := 0

    __New(DefinitionString) {
        Values := StrSplit(DefinitionString, ",")
        this.Name := Values[1]
        this.IconID := Values[2]
        this.Alias := (Values.Length >= 3 and (Values[3] != "")) ? Values[3] : this.Alias
        this.Delay := (Values.Length >= 4 and (Values[4] != "")) ? Values[4] : this.Delay
    }
}
