#!/bin/bash

# Waybar touchpad module.
#   (no args) / status  -> print waybar JSON (empty text if no touchpad exists)
#   toggle              -> enable/disable the touchpad and refresh waybar
#
# State is kept in a runtime file so it resets to "enabled" on reboot, matching
# Hyprland's default (touchpad enabled at startup).

STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/waybar-touchpad.state"

# Find the first touchpad device Hyprland knows about (name ends in -touchpad).
touchpad_name() {
    hyprctl devices -j 2>/dev/null \
        | jq -r '.mice[]?.name | select(endswith("-touchpad"))' \
        | head -n1
}

TP="$(touchpad_name)"

# No touchpad -> render nothing so the module is hidden.
if [ -z "$TP" ]; then
    [ "$1" != "toggle" ] && echo '{"text": ""}'
    exit 0
fi

# Current desired state (default: enabled).
state="enabled"
[ -f "$STATE_FILE" ] && state="$(cat "$STATE_FILE")"

case "$1" in
    toggle)
        if [ "$state" = "enabled" ]; then
            hyprctl keyword "device[$TP]:enabled" false >/dev/null
            echo "disabled" > "$STATE_FILE"
            notify-send -u low "Touchpad" "Disabled"
        else
            hyprctl keyword "device[$TP]:enabled" true >/dev/null
            echo "enabled" > "$STATE_FILE"
            notify-send -u low "Touchpad" "Enabled"
        fi
        # Force waybar to refresh this module.
        pkill -RTMIN+11 waybar 2>/dev/null || true
        ;;
    *)
        if [ "$state" = "enabled" ]; then
            echo '{"text": "󰟸", "class": "active", "tooltip": "Touchpad enabled"}'
        else
            echo '{"text": "󰤳", "class": "inactive", "tooltip": "Touchpad disabled"}'
        fi
        ;;
esac
