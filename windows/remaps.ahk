; TODO this needs simplifying/tidying. Can we split into a few scripts?

; TODO how can we auto-install/sync the windows stuff? Want to edit files in here, then run something to sync over perhaps?

; TODO possibly rewrite in AHK1

; TODO add key for `alt + space` then `m`

; -------------------- Settings
activate := "CapsLock"
; TODO Esc is sent many times, how to make it only send once? Does it mean StartRemap is being called multiple times? 
onActivate := "{Esc}"

up := "k"
right := "l"
down := "j"
left := "h"
slow := "d"
leftClick := "Space"
rightClick := ";"
scrollUp := "s"
scrollDown := "f"

openBrace := "e"
closeBrace := "i"

interval := 40
speed := 20
modifier := 0.2

; -------------------- Code
SetCapsLockState "AlwaysOff"
Ctrl & F12::ExitApp

Hotkey activate, StartRemap
Hotkey activate " Up", StopRemap

CoordMode "Mouse", "Screen"
slowMode := 1

StartRemap(ThisHotkey) {
    Send onActivate

    Hotkey openBrace, BraceOpen, "On"
    Hotkey closeBrace, BraceClose, "On"
    Hotkey up, MoveUp, "On"
    Hotkey right, MoveRight, "On"
    Hotkey down, MoveDown, "On"
    Hotkey left, MoveLeft, "On"
    Hotkey slow, ApplySlow, "On"
    Hotkey slow " Up", ResetSpeed, "On"
    Hotkey leftClick, ClickLeft, "On"
    Hotkey rightClick, ClickRight, "On"
    Hotkey scrollUp, UpScroll, "On"
    Hotkey scrollDown, DownScroll, "On"
}

StopRemap(ThisHotkey) {
    Hotkey openBrace, BraceOpen, "Off"
    Hotkey closeBrace, BraceClose, "Off"
    Hotkey up, MoveUp, "Off"
    Hotkey right, MoveRight, "Off"
    Hotkey down, MoveDown, "Off"
    Hotkey left, MoveLeft, "Off"
    Hotkey slow, ApplySlow, "Off"
    Hotkey slow " Up", ResetSpeed, "Off"
    Hotkey leftClick, ClickLeft, "Off"
    Hotkey rightClick, ClickRight, "Off"
    Hotkey scrollUp, UpScroll, "Off"
    Hotkey scrollDown, DownScroll, "Off"

    global slowMode
    slowMode := 1
}

MoveWhileKeyHeld(x, y, key) {
    global slowMode

    Loop {
        Sleep speed
        
        MouseGetPos &xpos, &ypos 
        
        ; Calculate diagonal movement vector
        xMove := 0
        yMove := 0
        
        if (GetKeyState(up, "P")) {
            yMove := -interval
        }
        if (GetKeyState(down, "P")) {
            yMove := interval
        }
        if (GetKeyState(left, "P")) {
            xMove := -interval
        }
        if (GetKeyState(right, "P")) {
            xMove := interval
        }
        
        xMove := xMove * slowMode
        yMove := yMove * slowMode
        
        if (!GetKeyState(key, "P")) {
            break
        }
        
        DllCall("SetCursorPos", "int", xpos + xMove, "int", ypos + yMove)
    }
}

ScrollWhileKeyHeld(direction) {
    while GetKeyState(direction, "P") {
      how := (direction = scrollUp ? "WheelUp" : "WheelDown")
        Click how
        Sleep 60
    }
}

BraceOpen(ThisHotkey) {
  Send "{{}"
}

BraceClose(ThisHotkey) {
  Send "{}}"
}

ClickLeft(ThisHotkey) {
    Click
}

ClickRight(ThisHotkey) {
    Click "Right"
}

UpScroll(ThisHotkey) {
    ScrollWhileKeyHeld(scrollUp)
}

DownScroll(ThisHotkey) {
    ScrollWhileKeyHeld(scrollDown)
}

MoveUp(ThisHotkey) {
    MoveWhileKeyHeld(0, -interval, up)
}

MoveRight(ThisHotkey) {
    MoveWhileKeyHeld(interval, 0, right)
}

MoveDown(ThisHotkey) {
    MoveWhileKeyHeld(0, interval, down)
}

MoveLeft(ThisHotkey) {
    MoveWhileKeyHeld(-interval, 0, left)
}

ApplySlow(ThisHotkey) {
    global modifier, slowMode
    if (slowMode == 1) { 
        slowMode := slowMode * modifier
    }
}

ResetSpeed(ThisHotkey) {
    global slowMode
    if (slowMode != 1) {
        slowMode := 1
    }
}


