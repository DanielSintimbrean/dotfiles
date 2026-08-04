-- migrated from apps/localsend.conf
---@module 'hl'

-- Float LocalSend and fzf file picker
hl.window_rule({ match = { class = "(Share|localsend)" }, float = true })
hl.window_rule({ match = { class = "(Share|localsend)" }, center = true })
