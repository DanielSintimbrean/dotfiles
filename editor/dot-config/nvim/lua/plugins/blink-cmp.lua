vim.pack.add {
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/folke/lazydev.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
}

require('luasnip').setup {}
require('luasnip.loaders.from_vscode').lazy_load()

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

---@module 'blink.cmp'
---@type blink.cmp.Config
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
    menu = {
      draw = {
        align_to = 'label',
        padding = 1,
        gap = 1,
        cursorline_priority = 10000,
        snippet_indicator = '~',
        treesitter = {},
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              return ctx.kind_icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              return { { group = ctx.kind_hl, priority = 20000 } }
            end,
          },
          kind = {
            ellipsis = false,
            width = { fill = true },
            text = function(ctx)
              return ctx.kind
            end,
            highlight = function(ctx)
              return ctx.kind_hl
            end,
          },
          label = {
            width = { fill = true, max = 60 },
            text = function(ctx)
              return ctx.label .. ctx.label_detail
            end,
            highlight = function(ctx)
              local highlights = {
                { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
              }
              if ctx.label_detail then table.insert(highlights, { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' }) end
              for _, idx in ipairs(ctx.label_matched_indices) do
                table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
              end
              return highlights
            end,
          },
          label_description = {
            width = { max = 20 },
            text = function(ctx)
              return ctx.label_description
            end,
            highlight = 'BlinkCmpLabelDescription',
          },
          source_name = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.source_name
            end,
            highlight = 'BlinkCmpSource',
          },
          source_id = {
            width = { max = 30 },
            text = function(ctx)
              return ctx.source_id
            end,
            highlight = 'BlinkCmpSource',
          },
        },
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      buffer = {
        score_offset = -100,
        enabled = function()
          local enabled_filetypes = {
            'markdown',
            'text',
          }
          return vim.tbl_contains(enabled_filetypes, vim.bo.filetype)
        end,
      },
    },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
