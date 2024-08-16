#Include StdOutToVar.ahk

checkForGitUpdateAndRestartIfNeeded() {
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
        showPopup("New updates found. Updating...")

        ; Pull the latest changes from the remote repository
        gitPullCmd := "git -C `"" scriptDir "`" pull"
        StdoutToVar(gitPullCmd)

        ; Restart the script after updating
        showPopup("Updated. Restarting application...")
        Reload  ; This restarts the AHK script
    }
    
    showPopup("Application up-to-date.")
}

; RunGitCommand(command) {
;     shell := ComObject("WScript.Shell")
;     exec := shell.Exec(command)
;     output := Trim(exec.StdOut.ReadAll())

;     return output
; }
