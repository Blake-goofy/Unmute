#Requires AutoHotkey v2.0
#SingleInstance Force

; Set to record titles only for Brave
recordedTitles := Map()

SetTimer(MonitorTitle, 100)  ; Check every 100ms

MonitorTitle() {
    if !WinActive("ahk_exe brave.exe")
        return
    title := WinGetTitle("A")
    if title and !recordedTitles.Has(title) {
        recordedTitles[title] := true
        FileAppend(title . "`n", "unique_titles.txt")
        TrayTip "New title recorded: " . title, "Title Recorder", 1
    }
}

; Press F12 to stop and show all recorded titles
F12:: {
    SetTimer(MonitorTitle, 0)  ; Stop the timer
    MsgBox("Recorded titles:`n" . JoinMap(recordedTitles))
}

JoinMap(map) {
    result := ""
    for key in map {
        result .= key . "`n"
    }
    return result
}

