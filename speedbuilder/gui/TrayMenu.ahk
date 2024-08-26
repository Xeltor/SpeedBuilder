; Tray menu handling
Tray := A_TrayMenu
Tray.Delete()
Tray.Add("Open", OpenTray)
Tray.Add()
Tray.Add("Restart", RestartTray)
Tray.Add("Exit", ExitTray)

OpenTray(*) {
    if !WinExist(AppName)
        SpecSelectionGui()
}

RestartTray(*) {
    Reload()
}

ExitTray(*) {
    ExitApp()
}