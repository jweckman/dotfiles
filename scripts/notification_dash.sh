#!/bin/bash

# Get the current date and time
dow=$(date '+%A')
date=$(date '+%Y-%m-%d')
time=$(date '+%H:%M:%S')

# Get computer battery percentage and check if it is greater than 0
power_level_raw=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage: | sed -E 's/.*percentage: *([0-9]+)%/\1/')
if [[ "$power_level_raw" -gt 0 ]]; then
    power_level="${power_level_raw}%"
else
    power_level=""
fi

# Check if headsetcontrol command is available
if command -v headsetcontrol &>/dev/null; then
    # Get headset battery percentage and validate it
    headset_power_level=$(headsetcontrol -b | grep Level | sed -E 's/.*Level: *([0-9]+%)$/\1/')
    if [[ ! "$headset_power_level" =~ ^[0-9]+%$ ]]; then
        headset_power_level=""
    fi
else
    headset_power_level=""
fi

# Construct the notification message
msg="$dow
$date"

if [[ -n "$power_level" ]]; then
    msg+=$'\n'"Computer Battery: $power_level"
fi

if [[ -n "$headset_power_level" ]]; then
    msg+=$'\n'"Headset Battery: $headset_power_level"
fi

output="$time"$'\n'"$msg"

# Uncomment this line to send a notification
# notify-send "$time" "$msg"

# Print the output
echo "$output"
