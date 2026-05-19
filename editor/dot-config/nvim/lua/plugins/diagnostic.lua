vim.pack.add {
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',
  'https://github.com/rachartier/tiny-code-action.nvim',
  'https://github.com/folke/snacks.nvim',
}

require('tiny-inline-diagnostic').setup {
  options = {
    add_messages = {
      display_count = true,
    },
    multilines = {
      enabled = true,
    },
  },
}
vim.diagnostic.config { virtual_text = false }

require('tiny-code-action').setup {}
vim.keymap.set({ 'n', 'x' }, 'gra', function()
  require('tiny-code-action').code_action()
end, { noremap = true, silent = true, desc = '[G]oto Code [A]ction' })
