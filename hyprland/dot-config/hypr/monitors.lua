-- Monitors (migrated from monitors.conf)
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors: hyprctl monitors
---@module 'hl'

-- Straight 1x setup for low-resolution displays like 1080p or 1440p
hl.env("GDK_SCALE", "1")

-- Monitor definitions (initial state before handler kicks in)
hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = "1" })
-- hl.monitor({ output = "eDP-1", mode = "2560x1600@60", position = "0x0", scale = "1.67" })

-- monitor HDMI
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "auto", scale = "1" })

-- monitor from thunderbolt
-- hl.monitor({ output = "DP-2", mode = "1920x1080@143.60", position = "-1920x0", scale = "1" })
hl.monitor({ output = "DP-2", mode = "1920x1080@143.60", position = "0x-1080", scale = "1" })

-- Auto-switch handler (disabled, same as original .conf):
-- hl.on("hyprland.start", function() hl.exec_cmd("~/.config/hypr/scripts/monitor-handler.sh") end)
