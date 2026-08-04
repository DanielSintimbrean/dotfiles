-- Hyprland Lua configuration (migrated from hyprland.conf)
-- Since Hyprland 0.55 hyprlang (.conf) is deprecated in favor of Lua.
-- If this file exists it is loaded INSTEAD of hyprland.conf (checked at startup).
-- To revert to the old .conf setup, simply delete/rename this file.
--
-- Docs: https://wiki.hypr.land/Configuring/Start/
---@module 'hl'

-- Environment variables (incl. NVIDIA + xwayland + ecosystem tweaks)
require("envs")

-- Programs / window & layer rules
require("apps")
require("windows")

-- Autostart (exec-once -> hyprland.start)
require("autostart")

-- Input & appearance
require("input")
require("looknfeel")
require("monitors")

-- Keybindings
require("bindings")
require("bindings.media")
require("bindings.tiling")
require("bindings.utilities")
require("bindings.clipboard")

-- NOTE: Omarchy integration that used .conf `source` no longer applies under Lua:
--   * ~/.config/omarchy/current/theme/hyprland.conf  (border color; was already commented out)
--   * ~/.local/state/omarchy/toggles/hypr/*.conf      (dynamic toggle flags; currently empty)
-- `omarchy refresh hyprland` and future `omarchy update` migrations edit .conf, which is now ignored.
