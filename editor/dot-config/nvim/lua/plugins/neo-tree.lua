vim.pack.add({
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
  'https://github.com/MunifTanjim/nui.nvim',
})

require"neo-tree".setup({
    close_if_last_window = true,
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
        },
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
     },
})

vim.keymap.set("n", '\\', ':Neotree reveal right<CR>', {desc = 'NeoTree reveal', silent = true })
