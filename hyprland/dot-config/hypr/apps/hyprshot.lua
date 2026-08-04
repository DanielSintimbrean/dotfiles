-- migrated from apps/hyprshot.conf
---@module 'hl'

-- Remove 1px border around hyprshot screenshots
hl.layer_rule({
    match = { namespace = "selection" },
    no_anim = true,
})
