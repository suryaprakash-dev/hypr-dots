#!/bin/env bash
# Path to the icons for notifications
ICON_PATH="$HOME/.config/dunst/icons"
# Directory where screen recordings will be saved
DIRECTORY="$HOME/Videos/screenrecord"

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    mkdir -p "$DIRECTORY"
fi

# Check if wf-recorder is running
if pgrep -x "wf-recorder" > /dev/null; then
    pkill -INT -x wf-recorder
    notify-send -i "$ICON_PATH/recording-stop.png" -h string:wf-recorder:record -t 2500 "Finished Recording" "Saved at $DIRECTORY"
    # Update Waybar status
    swaymsg "exec ~/.config/hypr/scripts/recording_status.sh"
    exit 0
fi

# Get the current date and time for the filename
dateTime=$(date +%a-%b-%d-%y-%H:%M:%S)

# Notify the user that recording will start
notify-send -i "$ICON_PATH/recording.png" -h string:wf-recorder:record -t 1500 "Recording Started" "Recording your screen..."

# Start the screen recording (wf-recorder will automatically use the primary display)
wf-recorder --bframes max_b_frames -f "$DIRECTORY/$dateTime.mp4" &