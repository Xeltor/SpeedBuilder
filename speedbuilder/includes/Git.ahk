#Include StdOutToVar.ahk

GitCheckStatus(state := "status") {
    gitStatusCmd := "git status -uno"
    gitStatus := StdoutToVar(gitStatusCmd, A_ScriptDir)

    if InStr(gitStatus.Output, "Your branch is behind") and state = "status" {
        return true
    } else if InStr(gitStatus.Output, "Merge bullshit fix this") and state = "changes" {
        return true
    }

    return false
}

checkForGitUpdateAndRestartIfNeeded() {
    try {
        ; Check if the folder is a Git repository
        gitCheckCmd := "git rev-parse --is-inside-work-tree"
        isGitRepo := StdoutToVar(gitCheckCmd, A_ScriptDir)

        if (!InStr(isGitRepo.Output, "true")) {
            return
        }
        showPopup("Checking for updates.")

        ; Fetch updates from the remote repository
        gitFetchCmd := "git fetch"
        StdoutToVar(gitFetchCmd, A_ScriptDir)

        ; Check if the branch is behind
        if GitCheckStatus() {
            if MsgBox("Update available, update HACK now?", AppName, "0x24") = "No" {
                return
            }

            ; Check local changes
            if GitCheckStatus("changes") {
                if MsgBox("Local changes detected, overwrite?", AppName, "0x24") = "No" {
                    return
                }

                ; Reset local changes.
                gitResetCmd := "git restore ."
                gitReset := StdoutToVar(gitResetCmd, A_ScriptDir)

                if GitCheckStatus("changes") {
                    MsgBox("Unable to overwrite local changes.`n`nGo pester Xeltor or run 'git restore .' manually in the folder.", AppName, "0x10")
                    return
                }
            }

            ; Pull the latest changes from the remote repository
            showPopup("Updating HACK.")
            gitPullCmd := "git pull"
            StdoutToVar(gitPullCmd, A_ScriptDir)

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