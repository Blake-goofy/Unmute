#Requires AutoHotkey v2.0
#SingleInstance Force
TraySetIcon("multitwitch.ico")  ; any icon

global prevTitle := ""
global checkPeriod := 1000

SetTimer(CheckActive, checkPeriod)

CheckActive() {
    global prevTitle, checkPeriod
    local win, title, x, y, w, h, mouseX, mouseY
    win := WinExist("A")
    if !win
        return
    ; Brave only. Change to chrome.exe if needed.
    if !WinActive("ahk_exe brave.exe")
        return
    title := WinGetTitle("ahk_id " . win)
    
    ; Adjust check frequency based on title
    if StrLower(title) == "multitwitch live selector - brave"
        checkPeriod := 10
    else
        checkPeriod := 1000
    SetTimer(CheckActive, checkPeriod)
    
    ; Only unmute when title changes from loading to final
    if !( (StrLower(prevTitle) == "untitled - brave" or InStr(StrLower(prevTitle), "multitwitch.tv/") == 1) and StrLower(title) == "multitwitch - brave" )
        {
            prevTitle := title
            return
        }

    WinActivate("ahk_id " . win)
    Sleep(1000)

    ; Remember previous mouse position
    MouseGetPos(&mouseX, &mouseY)

    ; Click center to give the Twitch iframe keyboard focus
    WinGetPos(&x, &y, &w, &h, "ahk_id " . win)
    CoordMode("Mouse", "Screen")
    MouseMove(x + w // 2, y + h // 2, 0)
    Click()
    Sleep(100)

    ; Unmute
    Send("m")

    ; Move mouse back to previous position
    MouseMove(mouseX, mouseY, 0)

    prevTitle := title
}
