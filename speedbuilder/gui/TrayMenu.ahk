; Tray menu handling
Tray := A_TrayMenu
Tray.Delete()
Tray.Add("Open", OpenTray)
Tray.Add("Exit", ExitTray)

OpenTray(*) {
    if !WinExist(AppName)
        SpecSelectionGui()
}

ExitTray(*) {
    ExitApp()
}