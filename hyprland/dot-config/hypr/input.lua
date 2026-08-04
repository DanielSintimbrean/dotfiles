-- Input devices (migrated from input.conf)
-- See https://wiki.hypr.land/Configuring/Variables/#input
---@module 'hl'

hl.config({
    input = {
        -- Multiple keyboard layouts, switch with Left Alt + Space
        kb_layout  = "us,es",
        kb_variant = "intl",
        kb_options = "grp:alt_space_toggle",

        -- Speed of keyboard repeat
        repeat_rate  = 40,
        repeat_delay = 600,

        -- Start with numlock on by default
        numlock_by_default = true,

        touchpad = {
            -- Natural (inverse) scrolling
            natural_scroll = true,
            -- Two-finger clicks for right-click instead of lower-right corner
            clickfinger_behavior = true,
            -- Scrolling speed
            scroll_factor = 0.4,
        },
    },
})

-- Scroll nicely in the terminal
hl.window_rule({
    name  = "term-scroll-touchpad",
    match = { class = "(Alacritty|kitty|foot)" },
    scroll_touchpad = 1.5,
})
hl.window_rule({
    name  = "ghostty-scroll-touchpad",
    match = { class = "com.mitchellh.ghostty" },
    scroll_touchpad = 0.2,
})

-- Touchpad gestures for changing workspaces (disabled, same as original):
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
