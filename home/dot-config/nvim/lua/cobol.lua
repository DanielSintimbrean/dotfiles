local M = {}

function M.root(bufnr)
  return vim.fs.root(bufnr, { 'superbol.toml', '.git', 'Makefile' }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
end

M.lsp = {
  -- The JS build cannot serialize OCaml closures in its persistent cache.
  cmd = { 'superbol', 'lsp', '--no-caching', '--storage-directory', vim.fn.stdpath 'cache' .. '/superbol' },
  filetypes = { 'cobol' },
  root_dir = function(bufnr, on_dir)
    on_dir(M.root(bufnr))
  end,
  settings = {
    superbol = {
      cobol = { dialect = 'default', sourceFormat = 'free' },
    },
  },
  before_init = function(_, config)
    -- SuperBOL also discovers projects per source directory. Use absolute COPY paths.
    config.settings.superbol.cobol.copybooks = {
      { dir = config.root_dir .. '/copybooks' },
      { dir = config.root_dir },
      { dir = '.', ['file-relative'] = true },
    }
  end,
}

return M
