vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

---@module 'conform'
---@type conform.setupOpts
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = {}

    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        lsp_format = 'fallback',
      }
    end
  end,
  default_format_opts = {
    timeout_ms = 10000,
    async = true,
    quiet = false,
    lsp_format = 'never',
    require_cwd = true,
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
    javascriptreact = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
    typescript = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
    typescriptreact = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
  },
  formatters = {
    prettier = { require_cwd = true },
    biome = { require_cwd = true },
    ['biome-check'] = { require_cwd = true },
    ['biome-organize-imports'] = { require_cwd = true },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })
