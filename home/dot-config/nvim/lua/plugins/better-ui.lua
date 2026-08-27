vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/rcarriga/nvim-notify',
}

require('notify').setup {
  background_colour = '#000000',
}

require('noice').setup {
  lsp = {
    hover = {
      silent = true,
    },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
}

vim.keymap.set('n', '<leader>nd', function()
  require('notify').dismiss { pending = true, silent = true }
end, { desc = 'Dismiss notifications' })
