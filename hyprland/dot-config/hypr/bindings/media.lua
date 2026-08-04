-- Media keys (migrated from bindings/media.conf)
-- bindeld -> { repeating = true, locked = true, description = ... }
-- bindld  -> { locked = true, description = ... }
---@module 'hl'

-- Only display the OSD on the currently focused monitor
local osd = [[swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"]]

local repeatLocked = function(desc) return { repeating = true, locked = true, description = desc } end
local locked       = function(desc) return { locked = true, description = desc } end

-- Laptop multimedia keys for volume and LCD brightness (with OSD)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(osd .. " --output-volume raise"),      repeatLocked("Volume up"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(osd .. " --output-volume lower"),      repeatLocked("Volume down"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(osd .. " --output-volume mute-toggle"), repeatLocked("Mute"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(osd .. " --input-volume mute-toggle"),  repeatLocked("Mute microphone"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(osd .. " --brightness raise"),          repeatLocked("Brightness up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(osd .. " --brightness lower"),          repeatLocked("Brightness down"))

-- Precise 1% multimedia adjustments with Alt modifier
hl.bind("ALT + XF86AudioRaiseVolume",  hl.dsp.exec_cmd(osd .. " --output-volume +1"), repeatLocked("Volume up precise"))
hl.bind("ALT + XF86AudioLowerVolume",  hl.dsp.exec_cmd(osd .. " --output-volume -1"), repeatLocked("Volume down precise"))
hl.bind("ALT + XF86MonBrightnessUp",   hl.dsp.exec_cmd(osd .. " --brightness +1"),    repeatLocked("Brightness up precise"))
hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd(osd .. " --brightness -1"),    repeatLocked("Brightness down precise"))

hl.bind("SHIFT + XF86MonBrightnessUp",   hl.dsp.exec_cmd("hyprctl hyprsunset temperature +500"), repeatLocked("Brightness up precise"))
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -500"), repeatLocked("Brightness down precise"))

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(osd .. " --playerctl next"),       locked("Next track"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(osd .. " --playerctl play-pause"), locked("Pause"))
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(osd .. " --playerctl play-pause"), locked("Play"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(osd .. " --playerctl previous"),   locked("Previous track"))

-- Switch audio output with Super + Mute
hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("omarchy-cmd-audio-switch"), locked("Switch audio output"))
