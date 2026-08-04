-- migrated from apps/work.conf
---@module 'hl'

hl.window_rule({ match = { class = "([Mm]icrosoft-edge)" }, tag = "+edge" })
hl.window_rule({ match = { class = "(teams-for-linux)" }, tag = "+teams" })
hl.window_rule({ match = { class = "(vesktop)" }, tag = "+discord" })

hl.window_rule({ match = { tag = "edge" }, workspace = "7 silent" })
hl.window_rule({ match = { tag = "teams" }, workspace = "8 silent" })
hl.window_rule({ match = { tag = "discord" }, workspace = "6 silent" })
