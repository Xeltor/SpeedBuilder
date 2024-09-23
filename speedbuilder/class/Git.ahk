#Include ..\includes\StdOutToVar.ahk

class Git {
    Ready := unset

    __New() {
        this.Ready := InStr(StdoutToVar("git -v", A_ScriptDir).Output, "git version") and this.IsRepo()
    }

    Update() {
        this.Fetch()

        if !this.HasUpdates() {
            showPopup("HACK is up-to-date.")
            return
        }

        if MsgBox("Update available, update HACK now?", AppName, "0x24") = "No" {
            return
        }

        if this.HasLocalChanges() {
            if MsgBox("Local changes detected, overwrite?", AppName, "0x24") = "No" {
                return
            }
        }
        else if !this.Restore() 
            return

        this.Pull()
        
        ; Restart the script after updating
        i := 3
        while (i > 0) {
            showPopup("Restarting HACK in " i " second" (i > 1 ? "s" : "") ".")
            i--
            Sleep(1000)
        }

        Reload
    }

    IsRepo() {
        return InStr(StdoutToVar("git rev-parse --is-inside-work-tree", A_ScriptDir).Output, "true")
    }

    HasUpdates() {
        return InStr(StdoutToVar("git status -uno", A_ScriptDir).Output, "Your branch is behind")
    }

    HasLocalChanges() {
        return InStr(StdoutToVar("git status -uno", A_ScriptDir).Output, "Changes not staged for commit")
    }

    Fetch() {
        showPopup("Checking for updates.")
        StdoutToVar("git fetch", A_ScriptDir)
        return true
    }

    Restore() {
        StdoutToVar("git restore .", A_ScriptDir)

        if this.HasLocalChanges() {
            MsgBox("Unable to overwrite local changes.`n`nGo pester Xeltor or run 'git restore .' manually in the folder.", AppName, "0x10")
            return false
        }
    }

    Pull() {
        showPopup("Updating HACK.")
        StdoutToVar("git pull", A_ScriptDir)

        return !this.HasUpdates()
    }
}