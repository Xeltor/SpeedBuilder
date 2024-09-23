; Tray menu handling
Tray := A_TrayMenu
Tray.Delete()
Tray.Add("Open", OpenTray)
Tray.Add()
Tray.Add("Check for updates", UpdatesTray)
Tray.Add("Restart", RestartTray)
Tray.Add("Exit", ExitTray)

OpenTray(*) {
    if !WinExist(AppName)
        MainGui.Show()
}

UpdatesTray(*) {
    checkForGitUpdateAndRestartIfNeeded()
}

RestartTray(*) {
    Reload()
}

ExitTray(*) {
    ExitApp()
}