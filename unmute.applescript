global prevTitle
set prevTitle to ""

-- Add a log at the start to indicate the script has started
log "Unmute script started and running..."

repeat
    tell application "System Events"
        set frontApp to name of first application process whose frontmost is true
        set shouldPerformMouseOps to false
        
        if frontApp is "Brave Browser" then
            try
                tell application "Brave Browser"
                    -- Check if there are any windows open
                    if (count of windows) > 0 then
                        set currentTitle to title of front window
                        -- Log when a new title is detected
                        if currentTitle is not equal to prevTitle then
                            log "New title detected: " & currentTitle
                        end if
                        
                        -- Check if title changed from loading to final
                        -- log "Checking condition: prevTitle='" & prevTitle & "', currentTitle='" & currentTitle & "'"
                        if ((prevTitle is "Untitled" or prevTitle starts with "multitwitch.tv") and (currentTitle starts with "multitwitch")) then
                            -- Activate the window
                            activate
                            delay 2
                            
                            -- Set flag to perform mouse operations
                            set shouldPerformMouseOps to true
                            
                            -- Log before mouse operations
                            -- log "About to perform mouse operations"
                        else
                            set shouldPerformMouseOps to false
                            -- log "Condition not met for mouse operations"
                        end if
                        
                        set prevTitle to currentTitle
                    else
                        -- log "No Brave Browser windows open"
                        set shouldPerformMouseOps to false
                        set prevTitle to ""
                    end if
                end tell
            on error errMsg
                -- log "Error accessing Brave Browser: " & errMsg
                set shouldPerformMouseOps to false
                set prevTitle to ""
            end try
            
            -- Get window bounds outside the Brave Browser tell block
            if shouldPerformMouseOps then
                try
                    tell application "Brave Browser"
                        if (count of windows) > 0 then
                            set winBounds to bounds of front window
                            set centerX to (item 1 of winBounds) + ((item 3 of winBounds) - (item 1 of winBounds)) / 2
                            set centerY to (item 2 of winBounds) + ((item 4 of winBounds) - (item 2 of winBounds)) / 2
                            -- Convert to integers for cliclick
                            set centerX to round centerX
                            set centerY to round centerY
                            -- log "Ready to perform mouse operations at " & centerX & ", " & centerY
                        else
                            set shouldPerformMouseOps to false
                        end if
                    end tell
                on error errMsg
                    -- log "Error getting window bounds: " & errMsg
                    set shouldPerformMouseOps to false
                end try
            end if
        else
            set shouldPerformMouseOps to false
        end if
        
        -- Handle mouse operations in System Events context
        if shouldPerformMouseOps then
            tell application "System Events"
                -- Wait 1 second
                delay 1
                
                -- log "About to click at " & centerX & "," & centerY
                
                -- Use cliclick with left click (using correct path)
                try
                    do shell script "/usr/local/bin/cliclick c:" & centerX & "," & centerY
                    -- log "Successfully clicked using cliclick"
                on error errMsg
                    -- log "cliclick failed: " & errMsg
                end try
                
                delay 0.5
                
                -- Send 'm' to unmute
                keystroke "m"
                -- log "Sent 'm' keystroke to unmute"
            end tell            
        end if
    end tell
    delay 0.1
end repeat