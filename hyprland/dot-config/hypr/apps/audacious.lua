-- migrated from apps/audacious.conf
---@module 'hl'

hl.window_rule({ match = { class = "(audacious)" }, tag = "+audacious" })
hl.window_rule({ match = { tag = "audacious" }, workspace = "9" })
