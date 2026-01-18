#!/usr/bin/env bash
set -euo pipefail

# Caffeine mode - prevents screen lock when enabled
# Eye open = caffeine active (no lock)
# Eye closed = normal behavior (lock enabled)

ICON_AWAKE=" 󰈈 "   # Eye open - screen stays awake
ICON_NORMAL=" 󰈉 "  # Eye closed - normal lock behavior
SIGNAL_NUMBER=10

is_caffeine_active() {
  ! pgrep -x hypridle >/dev/null
}

print_icon() {
  if is_caffeine_active; then
    printf '%s\n' "$ICON_AWAKE"
  else
    printf '%s\n' "$ICON_NORMAL"
  fi
}

toggle_caffeine() {
  if is_caffeine_active; then
    hypridle &
    disown
    notify-send "Caffeine disabled" "Screen will lock normally"
  else
    pkill -x hypridle || true
    notify-send "Caffeine enabled" "Screen lock disabled"
  fi
  pkill -RTMIN+"$SIGNAL_NUMBER" waybar >/dev/null 2>&1 || true
}

case "${1:-}" in
  toggle)
    toggle_caffeine
    ;;
  *)
    print_icon
    ;;
esac
