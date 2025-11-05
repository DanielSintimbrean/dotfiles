return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
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
      vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
    end,
  },
  {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      {
        'folke/snacks.nvim',
        opts = {
          terminal = {},
        },
      },
    },
    event = 'LspAttach',
    config = function()
      require('tiny-code-action').setup {}

      vim.keymap.set({ 'n', 'x' }, 'gra', function()
        require('tiny-code-action').code_action()
      end, { noremap = true, silent = true })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
