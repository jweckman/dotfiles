#!/bin/bash

dow=$(date '+%A')
date=$(date '+%Y-%m-%d');
time=$(date '+%H:%M:%S');
msg="$time

$dow
$date"
notify-send "$msg"
