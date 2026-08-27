-- Personal bindings loaded after Omarchy's defaults.

-- Preserve Vim-style focus while keeping the displaced Omarchy actions.
hl.unbind("SUPER + J")
o.bind("SUPER + J", "Focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))

hl.unbind("SUPER + K")
o.bind("SUPER + K", "Focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")

hl.unbind("SUPER + L")
o.bind("SUPER + L", "Focus right", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind("SUPER + H", "Focus left", hl.dsp.focus({ direction = "l" }))

-- Keep workspaces 1-9 local to the current monitor and move windows silently.
-- Workspace 10 keeps Omarchy's default behavior.
for workspace = 1, 9 do
  local key = "code:" .. tostring(workspace + 9)

  hl.unbind("SUPER + " .. key)
  hl.unbind("SUPER + SHIFT + " .. key)
  hl.unbind("SUPER + SHIFT + ALT + " .. key)

  o.bind(
    "SUPER + " .. key,
    "Switch to workspace " .. workspace .. " on current monitor",
    hl.dsp.focus({ workspace = tostring(workspace), on_current_monitor = true })
  )
  o.bind(
    "SUPER + SHIFT + " .. key,
    "Move window silently to workspace " .. workspace,
    hl.dsp.window.move({ workspace = tostring(workspace), follow = false })
  )
  o.bind(
    "SUPER + SHIFT + ALT + " .. key,
    "Move window to workspace " .. workspace,
    hl.dsp.window.move({ workspace = tostring(workspace) })
  )
end

-- Preserve grouped-window ordering. Omarchy keeps group navigation on
-- SUPER+ALT+TAB and SUPER+ALT+SHIFT+TAB.
hl.unbind("SUPER + CTRL + LEFT")
hl.unbind("SUPER + CTRL + RIGHT")
o.bind("SUPER + CTRL + LEFT", "Move grouped window backward", hl.dsp.group.move_window({ forward = false }))
o.bind("SUPER + CTRL + RIGHT", "Move grouped window forward", hl.dsp.group.move_window({ forward = true }))

-- Monitor focus follows the pointer, matching the previous setup.
hl.unbind("SUPER + comma")
hl.unbind("SUPER + SHIFT + comma")
o.bind("SUPER + comma", "Focus monitor left", "~/.config/hypr/scripts/focus-monitor-warp.sh -1")
o.bind("SUPER + PERIOD", "Focus monitor right", "~/.config/hypr/scripts/focus-monitor-warp.sh +1")
o.bind(
  "SUPER + SHIFT + comma",
  "Swap workspace left",
  hl.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "-1" })
)
o.bind(
  "SUPER + SHIFT + PERIOD",
  "Swap workspace right",
  hl.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" })
)
o.bind("SUPER + semicolon", "Dismiss last notification", "omarchy-shell notifications dismissOne")
o.bind("SUPER + SHIFT + semicolon", "Dismiss all notifications", "omarchy-shell notifications dismissAll")

-- Keep SUPER+V for the clipboard manager and relocate universal paste.
local function send_shortcut_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end

local function active_window_is_terminal()
  local window = hl.get_active_window()
  if not window then
    return false
  end

  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return false
end

hl.unbind("SUPER + V")
o.bind("SUPER + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")
o.bind("SUPER + ALT + V", "Universal paste", function()
  if active_window_is_terminal() then
    send_shortcut_once("SHIFT", "Insert")()
  else
    send_shortcut_once("CTRL", "V")()
  end
end)

-- Personal application shortcuts that are still used.
o.bind("SUPER + B", "Browser", { omarchy = "browser" })
hl.unbind("SUPER + SHIFT + B")
o.bind("SUPER + SHIFT + B", "Chrome", { launch = "google-chrome-stable" })

hl.unbind("SUPER + SHIFT + W")
o.bind(
  "SUPER + SHIFT + W",
  "New raw Obsidian note",
  "~/.local/bin/omawrite-raw-note"
)

-- Hardware and capture shortcuts.
o.bind_toggle("SUPER + F3", "Toggle touchpad", "touchpad")
o.bind("SUPER + XF86AudioMute", "Switch audio output", "omarchy-audio-output-switch", { locked = true })
o.bind("SHIFT + PRINT", "Delayed fullscreen screenshot", "sleep 2 && omarchy-capture-screenshot fullscreen")

hl.unbind("SHIFT + XF86MonBrightnessUp")
hl.unbind("SHIFT + XF86MonBrightnessDown")
o.bind(
  "SHIFT + XF86MonBrightnessUp",
  "Increase night-light temperature",
  "hyprctl hyprsunset temperature +500",
  { locked = true, repeating = true }
)
o.bind(
  "SHIFT + XF86MonBrightnessDown",
  "Decrease night-light temperature",
  "hyprctl hyprsunset temperature -500",
  { locked = true, repeating = true }
)
o.bind(
  "CTRL + SHIFT + XF86MonBrightnessUp",
  "Brightness maximum",
  "omarchy-brightness-display 100%",
  { locked = true, repeating = true }
)
o.bind(
  "CTRL + SHIFT + XF86MonBrightnessDown",
  "Brightness minimum",
  "omarchy-brightness-display 1%",
  { locked = true, repeating = true }
)
