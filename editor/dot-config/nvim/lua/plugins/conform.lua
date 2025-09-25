return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
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
        async = true, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = 'never', -- not recommended to change
        require_cwd = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
        javascriptreact = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
        typescript = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
        typescriptreact = { 'prettier', 'biome', 'biome-check', 'biome-organize-imports' },
      },
      formatters = {
        prettier = {
          require_cwd = true,
        },
        biome = {
          require_cwd = true,
        },
        ['biome-check'] = {
          require_cwd = true,
        },
        ['biome-organize-imports'] = {
          require_cwd = true,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
