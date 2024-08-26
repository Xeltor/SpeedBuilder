#Include StdOutToVar.ahk

checkForGitUpdateAndRestartIfNeeded() {
    try {
        ; Get the current directory (where the script is running)
        scriptDir := A_ScriptDir

        ; Check if the folder is a Git repository
        gitCheckCmd := "git -C `"" scriptDir "`" rev-parse --is-inside-work-tree"
        isGitRepo := StdoutToVar(gitCheckCmd)

        if (!InStr(isGitRepo.Output, "true")) {
            return
        }
        showPopup("Checking for updates.")

        ; Fetch updates from the remote repository
        gitFetchCmd := "git -C `"" scriptDir "`" fetch"
        StdoutToVar(gitFetchCmd)

        ; Check for new commits using git status
        gitStatusCmd := "git -C `"" scriptDir "`" status -uno"
        gitStatus := StdoutToVar(gitStatusCmd)

        ; Check if the branch is behind
        if InStr(gitStatus.Output, "Your branch is behind") {
            if MsgBox("Update available, update HACK now?", AppName, "0x24") = "No" {
                return
            }

            ; Pull the latest changes from the remote repository
            showPopup("Updating HACK.")
            gitPullCmd := "git -C `"" scriptDir "`" pull"
            StdoutToVar(gitPullCmd)

            ; Restart the script after updating
            i := 5
            while(i > 0) {
                showPopup("Restarting HACK in " i " seconds.")
                i--
                Sleep(1000)
            }

            Reload
        }

        showPopup("HACK up-to-date.")
    } catch {
        showPopup("Could not update.")
    }
}
