#!/bin/bash
# Focus the next/previous monitor AND warp the cursor to its center.
# Usage: focus-monitor-warp.sh +1 | -1
dir="${1:-+1}"

# Lua config (0.55+): hyprctl dispatch takes hl.dsp.* expressions, not legacy dispatcher strings
hyprctl dispatch "hl.dsp.focus({ monitor = \"$dir\" })"

# Center of the now-focused monitor, in logical layout coordinates.
read -r cx cy < <(hyprctl monitors -j | jq -r '.[] | select(.focused) |
  "\((.x + (.width / .scale / 2)) | floor) \((.y + (.height / .scale / 2)) | floor)"')

[ -n "$cx" ] && hyprctl dispatch "hl.dsp.cursor.move({ x = $cx, y = $cy })"
