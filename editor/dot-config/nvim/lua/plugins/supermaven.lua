vim.pack.add { 'https://github.com/supermaven-inc/supermaven-nvim' }

require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<A-l>',
    clear_suggestion = '<C-]>',
    accept_word = '<A-k>',
  },
  ignore_filetypes = { cpp = true },
  color = {
    suggestion_color = '#AAAAAA',
    cterm = 244,
  },
  log_level = 'info',
  disable_inline_completion = false,
  disable_keymaps = false,
  condition = function()
    return false
  end,
}
