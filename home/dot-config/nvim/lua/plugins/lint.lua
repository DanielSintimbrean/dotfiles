vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
  cobol = { 'cobc' },
}

lint.linters.cobc = function()
  local root = require('cobol').root(0)
  return {
    cmd = 'cobc',
    env = { LC_ALL = 'C' },
    stdin = false,
    cwd = root,
    args = { '-free', '-fsyntax-only', '-Wall', '-fdiagnostics-plain-output', '-I', root .. '/copybooks', '-I', vim.fs.dirname(vim.api.nvim_buf_get_name(0)) },
    stream = 'stderr',
    ignore_exitcode = true,
    parser = function(output, bufnr, cwd)
      local diagnostics = {}
      local severities = { error = vim.diagnostic.severity.ERROR, warning = vim.diagnostic.severity.WARN, note = vim.diagnostic.severity.INFO }
      for line in output:gmatch '[^\r\n]+' do
        local file, row, severity, message = line:match '^(.+):(%d+): (%w+): (.+)$'
        if file then
          local lnum = tonumber(row) - 1
          local path = vim.fs.normalize(file:sub(1, 1) == '/' and file or cwd .. '/' .. file)
          if path ~= vim.api.nvim_buf_get_name(bufnr) then
            -- Keep errors inside COPY files visible on their including program.
            message = file .. ':' .. row .. ': ' .. message
            lnum = 0
            for i, source in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
              if source:lower():match '^%s*copy%s' and source:find(vim.fs.basename(file), 1, true) then
                lnum = i - 1
                break
              end
            end
          end
          table.insert(diagnostics, { lnum = lnum, col = 0, message = message, severity = severities[severity], source = 'GnuCOBOL' })
        end
      end
      return diagnostics
    end,
  }
end

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function(event)
    if vim.bo.filetype == 'cobol' then
      -- Check saved programs only. A copybook needs the context of its including program.
      if event.event == 'InsertLeave' or vim.bo.modified or vim.fn.expand('%:e'):lower() == 'cpy' or vim.fn.executable 'cobc' == 0 then
        return
      end
    end
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})
