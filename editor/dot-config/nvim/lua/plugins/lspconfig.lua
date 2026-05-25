vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',
}

require('mason').setup {}
require('fidget').setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>td', function()
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, '[T]oggle [D]iagnostics')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E ',
      [vim.diagnostic.severity.WARN] = 'W ',
      [vim.diagnostic.severity.INFO] = 'I ',
      [vim.diagnostic.severity.HINT] = 'H ',
    },
  } or {},
  virtual_text = false,
}

---@class LspServersConfig
---@field mason table<string, vim.lsp.Config>
---@field others table<string, vim.lsp.Config>
local servers = {
  mason = {
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
    ts_ls = {},
  },
  others = {
    -- dartls = {},
  },
}

local ensure_installed = vim.tbl_keys(servers.mason or {})
vim.list_extend(ensure_installed, {
  'stylua',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
  if not vim.tbl_isempty(config) then vim.lsp.config(server, config) end
end

require('mason-lspconfig').setup {
  ensure_installed = {},
  automatic_enable = true,
}

if not vim.tbl_isempty(servers.others) then vim.lsp.enable(vim.tbl_keys(servers.others)) end
