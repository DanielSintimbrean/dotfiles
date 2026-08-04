-- migrated from apps/browser.conf
---@module 'hl'

-- Browser types
hl.window_rule({ match = { class = "([cC]hrom(e|ium)|[bB]rave-browser|Vivaldi-stable)" }, tag = "+chromium-based-browser" })
hl.window_rule({ match = { class = "([fF]irefox|zen|librewolf)" }, tag = "+firefox-based-browser" })

-- Force chromium-based browsers into a tile to deal with --app bug
hl.window_rule({ match = { tag = "chromium-based-browser" }, tile = true })

hl.window_rule({ match = { tag = "firefox-based-browser" }, workspace = "1 silent" })
hl.window_rule({ match = { tag = "chromium-based-browser" }, workspace = "2 silent" })
hl.window_rule({ match = { class = "([gG]oogle-chrome)" }, workspace = "7 silent" })
