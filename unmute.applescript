global prevTitle
set prevTitle to ""

repeat
    tell application "System Events"
        set frontApp to name of first application process whose frontmost is true
        if frontApp is "Brave Browser" then
            tell application "Brave Browser"
                set currentTitle to title of front window
                -- Check if title changed from loading to final
                if ((prevTitle is "New Tab - Brave" or prevTitle is "New Tab" or prevTitle starts with "multitwitch.tv") and (currentTitle is "Multitwitch - Brave" or currentTitle is "Multitwitch")) then
                    -- Activate the window
                    activate
                    delay 1
                    
                    -- Get window bounds
                    set winBounds to bounds of front window
                    set centerX to (item 1 of winBounds) + ((item 3 of winBounds) - (item 1 of winBounds)) / 2
                    set centerY to (item 2 of winBounds) + ((item 4 of winBounds) - (item 2 of winBounds)) / 2
                    
                    -- Remember mouse position
                    set mousePos to position of mouse
                    
                    -- Move mouse to center
                    set position of mouse to {centerX, centerY}
                    delay 1
                    
                    -- Click
                    click mouse
                    delay 0.1
                    
                    -- Send 'm' to unmute
                    keystroke "m"
                    
                    -- Move mouse back
                    set position of mouse to mousePos
                end if
                set prevTitle to currentTitle
            end tell
        end if
    end tell
    delay 0.25
end repeat
