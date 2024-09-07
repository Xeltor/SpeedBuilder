#Include StdOutToVar.ahk

checkForGitUpdateAndRestartIfNeeded() {
    try {
        ; Get the current directory (where the script is running)
        scriptDir := A_ScriptDir

        ; Check if the folder is a Git repository
        gitCheckCmd := "git rev-parse --is-inside-work-tree"
        isGitRepo := StdoutToVar(gitCheckCmd, scriptDir)

        if (!InStr(isGitRepo.Output, "true")) {
            return
        }
        showPopup("Checking for updates.")

        ; Fetch updates from the remote repository
        gitFetchCmd := "git fetch"
        StdoutToVar(gitFetchCmd, scriptDir)

        ; Check for new commits using git status
        gitStatusCmd := "git status -uno"
        gitStatus := StdoutToVar(gitStatusCmd, scriptDir)

        ; Check if the branch is behind
        if InStr(gitStatus.Output, "Your branch is behind") {
            if MsgBox("Update available, update HACK now?", AppName, "0x24") = "No" {
                return
            }

            ; Check local changes
            if InStr(gitStatus.Output, "Changes not staged for commit") {
                if MsgBox("Local changes detected, overwrite?", AppName, "0x24") = "No" {
                    return
                }

                ; Reset local changes.
                gitResetCmd := "git restore ."
                gitReset := StdoutToVar(gitResetCmd, scriptDir)
            }

            ; Pull the latest changes from the remote repository
            showPopup("Updating HACK.")
            gitPullCmd := "git pull"
            StdoutToVar(gitPullCmd, scriptDir)

            ; Restart the script after updating
            i := 3
            while (i > 0) {
                showPopup("Restarting HACK in " i " second" (i > 1 ? "s" : "") ".")
                i--
                Sleep(1000)
            }

            Reload
        }

        showPopup("HACK is up-to-date.")
    } catch {
        showPopup("Could not update.")
    }
}