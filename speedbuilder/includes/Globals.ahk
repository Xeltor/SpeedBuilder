global Hekili := Object()
Hekili.Width := IniRead("config.ini", "Hekili", "BoxWidth", "50")
Hekili.xCoord := IniRead("config.ini", "Hekili", "xCoord", "100")
Hekili.yCoord := IniRead("config.ini", "Hekili", "yCoord", "100")

Pixel1 := Object()
Pixel1.xCoord := Hekili.xCoord - (Hekili.Width / 4)
Pixel1.yCoord := Hekili.yCoord - (Hekili.Width / 4)
Pixel2 := Object()
Pixel2.xCoord := Hekili.xCoord - (Hekili.Width / 4)
Pixel2.yCoord := Hekili.yCoord + (Hekili.Width / 4)
Hekili.Pixels := [Pixel1, Pixel2]

global Warcraft := "ahk_class GxWindowClass"

; Stop if warcraft isnt running.
if !WinExist(Warcraft) {
    MsgBox("Please make sure World of Warcraft is running.", AppName)
    ExitApp()
}