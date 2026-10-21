vim.bo.commentstring = '*> %s'
vim.bo.comments = ':*>'
vim.bo.textwidth = 0
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. ' | setlocal sw< sts<'
