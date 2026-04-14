-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal right<CR>', desc = 'NeoTree reveal', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    log_level = 'warn',
    close_if_last_window = true,
    window = {
      position = 'right',
    },
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      filtered_items = {
        visible = true, -- Show dotfiles by default
        hide_dotfiles = false, -- Don't hide dotfiles
        hide_gitignored = true, -- Still hide git-ignored files
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
