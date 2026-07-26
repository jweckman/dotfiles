#!/usr/bin/env bash
# cycle-audio-output.sh — cycle PipeWire default sink and notify.
set -euo pipefail

declare -a ids=() names=()
default_idx=-1
in_sinks=0

while IFS= read -r line; do
    # Section detection: "Sinks" / "Sinks (4):" / "Sink endpoints" skipped
    if [[ "$line" == *Sinks* && "$line" != *Sources* && "$line" != *endpoints* ]]; then
        in_sinks=1
        continue
    fi
    if [[ "$line" == *Sources* ]]; then
        in_sinks=0
        continue
    fi
    [ "$in_sinks" -eq 1 ] || continue

    # Strip leading tree-drawing chars + whitespace:
    #   "│    *   49. Device Name" -> "*   49. Device Name"
    #   "│       52. Device"      -> "52. Device"
    clean="$(printf '%s\n' "$line" | sed -E 's/^[^0-9*]+//')"
    [[ -n "$clean" ]] || continue

    if [[ "$clean" =~ ^(\*)?[[:space:]]*([0-9]+)\.[[:space:]]+(.*) ]]; then
        star="${BASH_REMATCH[1]}"
        id="${BASH_REMATCH[2]}"
        name="${BASH_REMATCH[3]}"
        # Strip trailing "(vol: X.XX)" and "[vol: X.XX]"
        name="$(printf '%s\n' "$name" | sed -E 's/[[:space:]]*(\(vol:[^)]*\)|\[vol:[^]]*\])//g')"
        # Trim trailing whitespace
        name="${name%"${name##*[![:space:]]}"}"
        ids+=("$id")
        names+=("$name")
        if [ -n "$star" ]; then
            default_idx=$(( ${#ids[@]} - 1 ))
        fi
    fi
done < <(wpctl status)

if [ "${#ids[@]}" -eq 0 ]; then
    notify-send -t 5000 "Audio Output" "No sinks found. Run 'wpctl status' to debug."
    exit 1
fi
: "${default_idx:=0}"

next_idx=$(( (default_idx + 1) % ${#ids[@]} ))
wpctl set-default "${ids[$next_idx]}" >/dev/null

vol="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2}')"
notify-send -t 2500 -h string:x-canonical-private-synchronous:audio-cycle \
    "Audio Output" "→ ${names[$next_idx]} (${vol:-?})"
