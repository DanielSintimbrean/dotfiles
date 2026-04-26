#!/bin/bash
# Monitor handler: when HDMI-A-1 is connected, use ONLY HDMI as output.
# Disables eDP-1 (laptop) and DP-2 when HDMI is active.
# Re-enables eDP-1 when HDMI is disconnected.

HDMI_PORT="HDMI-A-1"

handle_monitors() {
    if hyprctl monitors -j | jq -e ".[] | select(.name == \"$HDMI_PORT\")" > /dev/null 2>&1; then
        # HDMI connected: only use HDMI, disable all others
        hyprctl keyword monitor "eDP-1, disable"
        hyprctl keyword monitor "DP-2, disable"
    else
        # HDMI disconnected: re-enable laptop screen
        hyprctl keyword monitor "eDP-1, 2560x1600@60, 0x0, 1.67"
    fi
}

# Initial check on startup
sleep 2  # Let Hyprland finish initializing monitors
handle_monitors

# Listen for monitor connect/disconnect events via Hyprland IPC
socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    case "$line" in
        monitoraddedv2*|monitorremoved*)
            sleep 1  # Let Hyprland settle after the event
            handle_monitors
            ;;
    esac
done
