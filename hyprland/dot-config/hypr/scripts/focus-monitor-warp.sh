#!/bin/bash
# Focus the next/previous monitor AND warp the cursor to its center.
# Usage: focus-monitor-warp.sh +1 | -1
dir="${1:-+1}"

hyprctl dispatch focusmonitor "$dir"

# Center of the now-focused monitor, in logical layout coordinates.
read -r cx cy < <(hyprctl monitors -j | jq -r '.[] | select(.focused) |
  "\((.x + (.width / .scale / 2)) | floor) \((.y + (.height / .scale / 2)) | floor)"')

[ -n "$cx" ] && hyprctl dispatch movecursor "$cx" "$cy"
