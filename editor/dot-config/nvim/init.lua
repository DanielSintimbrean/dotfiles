-- [[ Setting options ]]
-- See `:help vim.o`
--  For more options, you can see `:help option-list`

vim.o.confirm = true
vim.o.cursorcolumn = false
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.ignorecase = true    -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
vim.o.incsearch = true
vim.o.list = true          -- Sets how neovim will display certain whitespace characters in the editor.
vim.o.listchars = 'tab:» ,trail:·,nbsp:␣,eol:↵,extends:↷,precedes:↶'
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.shiftwidth = 2
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.winborder = "rounded"
vim.o.wrap = false
vim.opt_local.conceallevel = 2

vim.g.mapleader = " "

vim.cmd([[set mouse=nv]]) -- Mouse only on normal and visual mode

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = 'https://github.com/NvChad/showkeys',             opt = true },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/catppuccin/nvim" },
})

vim.cmd [[colorscheme catppuccin-mocha]]

require "showkeys".setup({ position = "top-right" })
require "mini.animate".setup({
	scroll = { enable = false }
})
require "mini.ai".setup()
require "mini.pick".setup()
require "mini.statusline".setup()
require "oil".setup()

local map = vim.keymap.set

map('n', '<leader>lf', vim.lsp.buf.format)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

require('plugins.autopairs')
require('plugins.lsp')
require('plugins.neo-tree')
require('plugins.obsidian')
