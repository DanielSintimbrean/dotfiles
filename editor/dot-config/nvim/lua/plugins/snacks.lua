local plugins = { 'https://github.com/folke/snacks.nvim' }
if vim.g.have_nerd_font then table.insert(plugins, 'https://github.com/nvim-tree/nvim-web-devicons') end
vim.pack.add(plugins)

---@type snacks.Config
require('snacks').setup {
  scroll = { enabled = true },
  lazygit = { enabled = true },
  picker = {
    sources = {
      files = {
        hidden = true,
      },
    },
  },
  terminal = {},
  image = {
    doc = { inline = false, float = false },
  },
  dashboard = {
    preset = {
      header = [[
██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
   ]],
      -- stylua: ignore
      ---@type snacks.dashboard.Item[]
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = "󰒲 ", key = "p", desc = "Plugins", action = ":lua vim.pack.update()" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      { section = 'recent_files', padding = 1 },
    },
  },
}

vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.smart() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sF', function()
  Snacks.picker.files {
    hidden = true,
    ignored = true,
    args = { '--exclude', '.git', '--exclude', 'node_modules', '--exclude', '.next', '--exclude', '.turbo', '--exclude', 'dist' },
  }
end, { desc = '[S]earch all [F]iles (incl. gitignored)' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.pickers() end, { desc = '[S]earch [S]elect Snacks' })
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', function() Snacks.picker.recent() end, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function() Snacks.picker.lines {} end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>lg', function() Snacks.lazygit.open() end, { desc = '[L]azy [G]it' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', 'grr', require('snacks').picker.lsp_references, { buffer = event.buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', require('snacks').picker.lsp_implementations, { buffer = event.buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', require('snacks').picker.lsp_definitions, { buffer = event.buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { buffer = event.buf, desc = '[G]oto [D]eclaration' })
    vim.keymap.set('n', 'gO', require('snacks').picker.lsp_symbols, { buffer = event.buf, desc = 'Open Document Symbols' })
    vim.keymap.set('n', 'gW', require('snacks').picker.lsp_workspace_symbols, { buffer = event.buf, desc = 'Open Workspace Symbols' })
    vim.keymap.set('n', 'grt', require('snacks').picker.lsp_type_definitions, { buffer = event.buf, desc = '[G]oto [T]ype Definition' })
  end,
})
