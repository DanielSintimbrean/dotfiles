-- Tiling / window management bindings (migrated from bindings/tiling.conf)
---@module 'hl'

local function d(desc) return { description = desc } end

-- Close windows
hl.bind("SUPER + W",          hl.dsp.window.close(),                              d("Close active window"))
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("omarchy-cmd-close-all-windows"),  d("Close all Windows"))

-- Control tiling
-- hl.bind("SUPER + J", hl.dsp.layout("togglesplit"), d("Toggle split")) -- dwindle
hl.bind("SUPER + P",         hl.dsp.window.pseudo(),                        d("Pseudo window"))
hl.bind("SUPER + T",         hl.dsp.window.float({ action = "toggle" }),    d("Toggle floating"))
hl.bind("SUPER + F",         hl.dsp.window.fullscreen({ mode = "fullscreen" }),           d("Force full screen"))         -- was: fullscreen, 0
hl.bind("SUPER + CTRL + F",  hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }), d("Tiled full screen"))         -- was: fullscreenstate, 0 2
hl.bind("SUPER + ALT + F",   hl.dsp.window.fullscreen({ mode = "maximized" }),            d("Full width"))                -- was: fullscreen, 1

-- Move focus with SUPER + HJKL
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }),  d("Move focus left"))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }), d("Move focus right"))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }),    d("Move focus up"))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }),  d("Move focus down"))

-- Switch workspaces with SUPER + [1-9]  (code:10..18)
-- `on_current_monitor = true` keeps the old `focusworkspaceoncurrentmonitor` behavior on multi-monitor setups.
for i = 1, 9 do
    hl.bind("SUPER + code:" .. (9 + i), hl.dsp.focus({ workspace = tostring(i), on_current_monitor = true }), d("Switch to workspace " .. i))
end

-- Move active window to a workspace with SUPER + SHIFT + [1-9]  (silent move)
for i = 1, 9 do
    hl.bind("SUPER + SHIFT + code:" .. (9 + i), hl.dsp.window.move({ workspace = tostring(i), follow = false }), d("Move window to workspace " .. i))
end

-- TAB between workspaces
hl.bind("SUPER + CTRL + TAB", hl.dsp.focus({ workspace = "previous" }), d("Former workspace"))

-- Swap active window with SUPER + SHIFT + arrows
hl.bind("SUPER + SHIFT + LEFT",  hl.dsp.window.swap({ direction = "left" }),  d("Swap window to the left"))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "right" }), d("Swap window to the right"))
hl.bind("SUPER + SHIFT + UP",    hl.dsp.window.swap({ direction = "up" }),    d("Swap window up"))
hl.bind("SUPER + SHIFT + DOWN",  hl.dsp.window.swap({ direction = "down" }),  d("Swap window down"))

-- Cycle through applications on active workspace.
-- Original bound ALT+TAB to BOTH cyclenext and bringactivetotop; preserved via a function.
hl.bind("ALT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end, d("Cycle to next window"))
hl.bind("ALT + SHIFT + TAB", function()
    hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
    hl.dispatch(hl.dsp.window.bring_to_top())
end, d("Cycle to prev window"))

-- Resize active window (relative deltas)
hl.bind("SUPER + code:20",         hl.dsp.window.resize({ x = -100, y = 0, relative = true }), d("Expand window left"))  -- - key
hl.bind("SUPER + code:21",         hl.dsp.window.resize({ x = 100,  y = 0, relative = true }), d("Shrink window left"))  -- = key
hl.bind("SUPER + SHIFT + code:20", hl.dsp.window.resize({ x = 0, y = -100, relative = true }), d("Shrink window up"))
hl.bind("SUPER + SHIFT + code:21", hl.dsp.window.resize({ x = 0, y = 100,  relative = true }), d("Expand window down"))

-- Scroll through existing workspaces with SUPER + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), d("Scroll active workspace forward"))
hl.bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), d("Scroll active workspace backward"))

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Toggle groups
hl.bind("SUPER + G",       hl.dsp.group.toggle(),                    d("Toggle window grouping"))
hl.bind("SUPER + ALT + G", hl.dsp.window.move({ out_of_group = true }), d("Move active window out of group"))

-- Join groups
hl.bind("SUPER + ALT + LEFT",  hl.dsp.window.move({ into_group = "left" }),  d("Move window to group on left"))
hl.bind("SUPER + ALT + RIGHT", hl.dsp.window.move({ into_group = "right" }), d("Move window to group on right"))
hl.bind("SUPER + ALT + UP",    hl.dsp.window.move({ into_group = "up" }),    d("Move window to group on top"))
hl.bind("SUPER + ALT + DOWN",  hl.dsp.window.move({ into_group = "down" }),  d("Move window to group on bottom"))

-- Navigate a single set of grouped windows
hl.bind("SUPER + TAB",         hl.dsp.group.next(),                   d("Next window in group"))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.group.next({ forward = false }), d("Previous window in group"))

-- Reorder windows within a group
hl.bind("SUPER + CTRL + RIGHT", hl.dsp.group.move_window({ forward = true }),  d("Move tab forward in group"))
hl.bind("SUPER + CTRL + LEFT",  hl.dsp.group.move_window({ forward = false }), d("Move tab backward in group"))

-- Activate window in a group by number
for i = 1, 5 do
    hl.bind("SUPER + ALT + " .. i, hl.dsp.group.active({ index = i }), d("Switch to group window " .. i))
end

-- Switch between monitors
hl.bind("SUPER + Comma",  hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-monitor-warp.sh -1"), d("Focus monitor left"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-monitor-warp.sh +1"), d("Focus monitor right"))
hl.bind("SUPER + SHIFT + Comma",  hl.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "-1" }), d("Swap workspace left"))
hl.bind("SUPER + SHIFT + Period", hl.dsp.workspace.swap_monitors({ monitor1 = "current", monitor2 = "+1" }), d("Swap workspace right"))
