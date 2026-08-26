-- Route familiar applications to their usual numbered workspaces.
-- Omarchy's application tags are reused where possible.
o.window({ tag = "firefox-based-browser" }, { workspace = "1 silent" })
o.window({ tag = "chromium-based-browser" }, { workspace = "2 silent" })
o.window({ tag = "terminal" }, { workspace = "3" })

o.window("([cC]ode|[cC]ursor|dev\\.zed\\.Zed)", { workspace = "4 silent" })
o.window("t3code", { workspace = "5 silent" })
o.window("obsidian", { workspace = "5" })
o.window("vesktop", { workspace = "6 silent" })

-- These rules follow the generic Chromium rule so the specific workspace wins.
o.window("[gG]oogle-chrome", { workspace = "7 silent" })
o.window("[mM]icrosoft-edge", { workspace = "7 silent" })
o.window("teams-for-linux", { workspace = "8 silent" })
o.window("audacious", { workspace = "9" })
