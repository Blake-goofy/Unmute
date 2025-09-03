#!/bin/zsh
# Wrapper to run the AppleScript with a controlled PATH and logs
# Makes it safe to run from launchd/LaunchAgent

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
SCRIPT_PATH="/Users/blakebecker/repos/Unmute/unmute.applescript"
OUT_LOG="/tmp/com.blake.unmute.out.log"
ERR_LOG="/tmp/com.blake.unmute.err.log"

# Ensure logs exist and are writable
mkdir -p "$(dirname "$OUT_LOG")"
: >> "$OUT_LOG"
: >> "$ERR_LOG"

echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") - wrapper starting" >> "$OUT_LOG"

# Run the AppleScript (exec replaces this process with osascript)
exec /usr/bin/osascript "$SCRIPT_PATH" >>"$OUT_LOG" 2>>"$ERR_LOG"
