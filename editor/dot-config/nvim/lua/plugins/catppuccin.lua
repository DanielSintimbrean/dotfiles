vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

---@diagnostic disable-next-line: missing-fields
require('catppuccin').setup {
  no_italic = true,
}

vim.cmd.colorscheme 'catppuccin'
