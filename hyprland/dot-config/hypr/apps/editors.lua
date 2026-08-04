-- migrated from apps/editors.conf
---@module 'hl'

hl.window_rule({ match = { class = "([cC]ode|[cC]ursor|dev.zed.Zed)" }, tag = "+editors" })
hl.window_rule({ match = { class = "(t3code)" }, tag = "+agents" })

hl.window_rule({ match = { tag = "editors" }, workspace = "4 silent" })
hl.window_rule({ match = { tag = "agents" }, workspace = "5 silent" })
