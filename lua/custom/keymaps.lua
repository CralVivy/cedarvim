-- lua/custom/keymaps.lua  (replace the old BufferLineCycleNext/Prev mappings)

local map = vim.keymap.set
local utils = require 'custom.utils'

-- Buffer navigation (safe: use bufferline if available, fallback to bnext/bprev)
local function buffer_next()
  -- exists(':Cmd') -> 2 if the ex-command exists
  if vim.fn.exists ':BufferLineCycleNext' == 2 then
    vim.cmd 'BufferLineCycleNext'
  else
    vim.cmd 'bnext'
  end
end

local function buffer_prev()
  if vim.fn.exists ':BufferLineCyclePrev' == 2 then
    vim.cmd 'BufferLineCyclePrev'
  else
    vim.cmd 'bprevious'
  end
end

map('n', '<Tab>', buffer_next, { desc = 'Next buffer (safe)', silent = true })
map('n', '<S-Tab>', buffer_prev, { desc = 'Previous buffer (safe)', silent = true })

-- Smart buffer deletion (preserves layout)
map('n', '<leader>x', utils.smart_buf_delete, { desc = 'Smart close buffer (preserve layout)', silent = true })

-- New empty buffer
map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'New empty buffer', silent = true })

-- Toggle Neo-tree
map('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree', silent = true })

-- other keymaps unchanged...

-- -- lua/custom/keymaps.lua
--
-- local map = vim.keymap.set
-- local utils = require 'custom.utils'
--
-- -- Buffer navigation (NvChad Style)
-- map('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer (NvChad)', silent = true })
-- map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer (NvChad)', silent = true })
--
-- -- Smart buffer deletion (preserves layout)
-- map('n', '<leader>x', utils.smart_buf_delete, { desc = 'Smart close buffer (preserve layout)', silent = true })
--
-- -- New empty buffer
-- map('n', '<leader>bn', '<cmd>enew<CR>', { desc = 'New empty buffer', silent = true })
--
-- -- Toggle Neo-tree
-- map('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree', silent = true })
--
-- Require the theme switcher
-- Map <leader>tt to open the theme picker
vim.keymap.set('n', '<leader>tt', function()
  require('custom.theme_switcher').pick_theme()
end, { desc = 'Pick Theme', silent = true })

vim.keymap.set('n', '<leader>aa', '<Cmd>CodeCompanionChat<CR>', { desc = 'Toggle CodeCompanion Chat' })
vim.keymap.set('n', '<leader>ao', '<Cmd>CodeCompanionActions<CR>', { desc = 'Open CodeCompanion Actions' })
-- -- vim.keymap.set('n', '<leader>ar', '<Cmd>CodeCompanionReview<CR>', {desc = 'Review with CodeCompanion'})
-- -- vim.keymap.set('n', '<leader>at', '<Cmd>CodeCompanionTest<CR>', {desc = 'Test with CodeCompanion'})
