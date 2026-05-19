local plugins = {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then table.insert(plugins, 'https://github.com/nvim-tree/nvim-web-devicons') end

vim.pack.add(plugins)

vim.keymap.set('n', '\\', ':Neotree reveal right<CR>', { desc = 'NeoTree reveal', silent = true })

---@module 'neo-tree'
---@type neotree.Config
require('neo-tree').setup {
  log_level = 'warn',
  close_if_last_window = true,
  window = {
    position = 'right',
  },
  filesystem = {
    hijack_netrw_behavior = 'open_current',
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = true,
    },
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
