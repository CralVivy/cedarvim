-- lua/custom/runner.lua
-- A bloat-free universal code runner leveraging toggleterm

local M = {}

function M.run_code()
  -- Get file information
  local filetype = vim.bo.filetype
  -- Get absolute file paths to prevent shell execution path errors
  local file = vim.fn.expand('%:p')
  local file_no_ext = vim.fn.expand('%:p:r')
  
  if file == "" then
    vim.notify("No file to run.", vim.log.levels.WARN)
    return
  end

  -- Automatically save the file before running
  vim.cmd('silent! w')

  -- Define execution commands for different languages
  -- Java Note: `java %` compiles and runs single-file programs in memory (Java 11+)
  local cmds = {
    python = string.format("python3 '%s'", file),
    java = string.format("java '%s'", file),
    c = string.format("gcc -O2 '%s' -o '%s' && '%s'", file, file_no_ext, file_no_ext),
    cpp = string.format("g++ -O2 '%s' -o '%s' && '%s'", file, file_no_ext, file_no_ext),
    go = string.format("go run '%s'", file),
    rust = string.format("rustc '%s' && '%s'", file, file_no_ext),
    javascript = string.format("node '%s'", file),
    typescript = string.format("ts-node '%s'", file),
    sh = string.format("bash '%s'", file),
    lua = string.format("lua '%s'", file),
  }

  local cmd = cmds[filetype]
  
  if cmd then
    -- Send the command to the first toggleterm instance (it will open if hidden)
    require('toggleterm').exec(cmd)
    vim.notify("Running " .. filetype .. "...", vim.log.levels.INFO)
  else
    vim.notify("No runner configured for filetype: " .. filetype, vim.log.levels.WARN)
  end
end

return M
