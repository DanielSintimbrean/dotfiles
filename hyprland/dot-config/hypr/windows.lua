-- Global window rules (migrated from windows.conf)
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
---@module 'hl'

-- Ignore maximize requests from all apps
hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fully opaque windows (no dimming of unfocused windows)
hl.window_rule({
    name  = "opaque-all",
    match = { class = ".*" },
    opacity = "1 1",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
