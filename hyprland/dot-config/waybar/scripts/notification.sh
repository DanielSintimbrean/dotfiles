#!/usr/bin/env bash
set -euo pipefail

ICON_ENABLED="󰂜"
ICON_DISABLED="󰂠"
DISABLED_MODE="do-not-disturb"
DEFAULT_MODE="default"
SIGNAL_NUMBER=9

is_disabled() {
  makoctl mode | grep -q "$DISABLED_MODE"
}

print_icon() {
  if is_disabled; then
    printf '%s\n' "$ICON_DISABLED"
  else
    printf '%s\n' "$ICON_ENABLED"
  fi
}

toggle_mode() {
  if is_disabled; then
    makoctl mode -s "$DEFAULT_MODE"
  else
    makoctl mode -s "$DISABLED_MODE"
  fi
  pkill -RTMIN+"$SIGNAL_NUMBER" waybar >/dev/null 2>&1 || true
}

case "${1:-}" in
  toggle)
    toggle_mode
    ;;
  *)
    print_icon
    ;;
esac
