#!/bin/bash
# Dim the waybar instance(s) on unfocused monitors.
#
# Waybar has no notion of a "focused" monitor, so we listen to Hyprland's
# focusedmon events and rewrite a small CSS file that waybar (with
# reload_style_on_change) live-reloads. Each waybar window carries its output
# name as a CSS class, e.g. window#waybar.eDP-1, which is what we target.

set -u

# Opacity applied to bars on the UNFOCUSED monitor(s). 1.0 = fully opaque.
DIM="${WAYBAR_UNFOCUSED_OPACITY:-0.6}"

# Write the generated CSS into the live config dir, where style.css's relative
# @import resolves (GTK resolves @import against the symlink path, not its target).
CSS="${HOME}/.config/waybar/waybar-focus-opacity.css"

write_css() {
  local focused="$1" out="" mon
  while read -r mon; do
    [ -z "$mon" ] && continue
    if [ "$mon" = "$focused" ]; then
      out+="window#waybar.$mon { opacity: 1; }"$'\n'
    else
      out+="window#waybar.$mon { opacity: $DIM; }"$'\n'
    fi
  done < <(hyprctl monitors -j | jq -r '.[].name')
  printf '%s' "$out" > "$CSS"
}

# Initial state.
write_css "$(hyprctl monitors -j | jq -r '.[] | select(.focused).name')"

SOCK="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
socat -U - "UNIX-CONNECT:${SOCK}" | while read -r line; do
  case "$line" in
    focusedmon\>\>*)
      mon="${line#focusedmon>>}"
      write_css "${mon%%,*}"
      ;;
  esac
done
