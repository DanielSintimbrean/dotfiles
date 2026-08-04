-- migrated from apps/terminals.conf
---@module 'hl'

-- Define terminal tag to style them uniformly
hl.window_rule({ match = { class = "(Alacritty|kitty|com.mitchellh.ghostty|foot)" }, tag = "+terminal" })
hl.window_rule({ match = { tag = "terminal" }, workspace = "3" })
