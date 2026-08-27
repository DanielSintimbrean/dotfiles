vim.pack.add {
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
}

---@diagnostic disable-next-line: missing-fields
require('todo-comments').setup { signs = false }
