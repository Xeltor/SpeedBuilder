class Battlenet {
    Path := "C:\Program Files (x86)\Battle.net\Battle.net.exe"

    LaunchWoW() {
        Run("`"" this.Path "`" --exec=`"launch WoW`"")
    }

    Exists() {
        return FileExist(this.Path)
    }
}