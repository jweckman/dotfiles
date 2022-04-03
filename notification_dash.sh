#!/bin/bash

dow=$(date '+%A')
date=$(date '+%Y-%m-%d');
time=$(date '+%H:%M:%S');
power_level="$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage:)"
pl_arr=($power_level)
pl_percentage=${pl_arr[1]}

msg="$dow
$date
Battery: $pl_percentage
"

notify-send "$time" "$msg"
