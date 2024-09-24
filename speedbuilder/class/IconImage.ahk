class IconImage {
    __fdid := 0
    Dir := "speedbuilder/resources/icons/"
    File := ""

    fdid {
        get => this.__fdid
        set {
            this.File := this.Dir value ".png"
            this.__fdid := value
        }
    }

    __New(fdid) {
        this.fdid := fdid
    }

    Cached() {
        return FileExist(this.File)
    }

    Download(fdid) {
        try {
            ; Attempt to download
            Download("https://wago.tools/api/casc/" fdid "?download", this.Dir fdid ".blp")
    
            ; Attempt to convert
            RunWait("speedbuilder/resources/blpconverter.dll " A_WorkingDir "/" this.Dir fdid ".blp")

            ; Remove blp
            FileDelete(this.Dir fdid ".blp")
        } catch {
            return false
        }

        ; Return
        return true
    }
}