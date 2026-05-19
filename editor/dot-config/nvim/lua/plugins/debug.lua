vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',
}, { load = false })

local configured = false

local function setup_debug()
  if configured then return end
  configured = true

  vim.cmd.packadd 'nvim-dap'
  vim.cmd.packadd 'nvim-nio'
  vim.cmd.packadd 'nvim-dap-ui'
  vim.cmd.packadd 'mason-nvim-dap.nvim'
  vim.cmd.packadd 'nvim-dap-go'

  local dap = require 'dap'
  local dapui = require 'dapui'

  require('mason-nvim-dap').setup {
    automatic_installation = true,
    handlers = {},
    ensure_installed = {
      'delve',
    },
  }

  ---@diagnostic disable-next-line: missing-fields
  dapui.setup {
    icons = { expanded = 'v', collapsed = '>', current_frame = '*' },
    ---@diagnostic disable-next-line: missing-fields
    controls = {
      icons = {
        pause = '||',
        play = '>',
        step_into = 'in',
        step_over = 'over',
        step_out = 'out',
        step_back = 'back',
        run_last = '>>',
        terminate = 'stop',
        disconnect = 'disc',
      },
    },
  }

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  require('dap-go').setup {
    delve = {
      detached = vim.fn.has 'win32' == 0,
    },
  }
end

vim.keymap.set('n', '<F5>', function()
  setup_debug()
  require('dap').continue()
end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function()
  setup_debug()
  require('dap').step_into()
end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function()
  setup_debug()
  require('dap').step_over()
end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function()
  setup_debug()
  require('dap').step_out()
end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function()
  setup_debug()
  require('dap').toggle_breakpoint()
end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  setup_debug()
  local dap = require 'dap'

  ---@return dap.SourceBreakpoint
  local function find_bp()
    local buf_bps = require('dap.breakpoints').get(vim.fn.bufnr())[vim.fn.bufnr()]
    for _, candidate in ipairs(buf_bps or {}) do
      if candidate.line and candidate.line == vim.fn.line '.' then return candidate end
    end

    return { condition = '', logMessage = '', hitCondition = '', line = vim.fn.line '.' }
  end

  ---@param bp dap.SourceBreakpoint
  local function customize_bp(bp)
    local props = {
      Condition = {
        value = bp.condition,
        setter = function(v) bp.condition = v end,
      },
      ['Hit Condition'] = {
        value = bp.hitCondition,
        setter = function(v) bp.hitCondition = v end,
      },
      ['Log Message'] = {
        value = bp.logMessage,
        setter = function(v) bp.logMessage = v end,
      },
    }
    local menu_options = vim.tbl_keys(props)
    vim.ui.select(menu_options, {
      prompt = 'Edit Breakpoint',
      format_item = function(item) return ('%s: %s'):format(item, props[item].value) end,
    }, function(choice)
      if choice == nil then return end
      props[choice].setter(vim.fn.input {
        prompt = ('[%s] '):format(choice),
        default = props[choice].value,
      })
      dap.set_breakpoint(bp.condition, bp.hitCondition, bp.logMessage)
    end)
  end

  customize_bp(find_bp())
end, { desc = 'Debug: Edit Breakpoint' })
vim.keymap.set('n', '<F7>', function()
  setup_debug()
  require('dapui').toggle()
end, { desc = 'Debug: See last session result.' })
