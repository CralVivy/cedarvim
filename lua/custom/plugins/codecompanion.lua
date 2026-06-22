return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  event = 'VeryLazy',
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionSave', 'CodeCompanionLoad', 'CodeCompanionDelete' },
  opts = {
    display = {
      chat = {
        window = {
          width = 0.26,
          height = 0.5,
          layout = 'vertical',
          border = 'single',
          position = 'topright',
        },
      },
    },
  },
  config = function(_, opts)
    require('codecompanion').setup(opts)

    -- SAVE CHAT (with overwrite confirmation)
    vim.api.nvim_create_user_command('CodeCompanionSave', function(args)
      local codecompanion = require 'codecompanion'
      local ok, chat = pcall(codecompanion.buf_get_chat, 0)
      if not ok or not chat then
        vim.notify('⚠️ Run inside a CodeCompanion chat buffer', vim.log.levels.ERROR)
        return
      end
      if #args.fargs == 0 then
        vim.notify('❗ Provide a filename: :CodeCompanionSave <filename>', vim.log.levels.ERROR)
        return
      end

      local Path = require 'plenary.path'
      local data = vim.fn.stdpath 'data'
      local folder = Path:new(data, 'cc_saves')
      if not folder:exists() then
        folder:mkdir { parents = true }
      end

      local fname = table.concat(args.fargs, '-') .. '.md'
      local filepath = folder:joinpath(fname)

      -- Confirm overwrite if file exists
      if filepath:exists() then
        local choice = vim.fn.confirm('File exists: ' .. fname .. '. Overwrite?', '&Yes\n&No', 2)
        if choice ~= 1 then
          vim.notify '❌ Save canceled.'
          return
        end
      end

      local buffer_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      -- Trim trailing blank lines
      while #buffer_lines > 0 and buffer_lines[#buffer_lines]:match '^%s*$' do
        table.remove(buffer_lines)
      end

      filepath:write(table.concat(buffer_lines, '\n'), 'w')
      vim.notify('💾 Chat saved to: ' .. filepath.filename)
    end, { nargs = '*' })

    -- LOAD CHAT
    vim.api.nvim_create_user_command('CodeCompanionLoad', function()
      require('snacks').picker.files {
        prompt = '📂 Load CodeCompanion Chat',
        cwd = vim.fn.stdpath 'data' .. '/cc_saves',
        confirm = function(picker, item)
          picker:close()
          if item and item.file then
            vim.cmd('edit ' .. item.file)
          end
        end,
      }
    end, {})

    -- DELETE CHAT
    vim.api.nvim_create_user_command('CodeCompanionDelete', function()
      local Path = require 'plenary.path'
      local save_dir = vim.fn.stdpath 'data' .. '/cc_saves'

      require('snacks').picker.files {
        prompt = '🗑️ Delete CodeCompanion Chat',
        cwd = save_dir,
        confirm = function(picker, item)
          picker:close()
          if not item or not item.file then return end
          local full_path = item.file
          local path = Path:new(full_path)
          if path:exists() then
            path:rm()
            vim.notify('🗑️ Deleted: ' .. full_path)
          else
            vim.notify('❌ File not found: ' .. full_path, vim.log.levels.ERROR)
          end
        end,
      }
    end, {})

    -- KEYMAPS
    vim.keymap.set('n', '<leader>as', ':CodeCompanionSave ', { desc = '💾 Save CodeCompanion Chat' })
    vim.keymap.set('n', '<leader>al', ':CodeCompanionLoad<CR>', { desc = '📂 Load CodeCompanion Chat' })
    vim.keymap.set('n', '<leader>ad', ':CodeCompanionDelete<CR>', { desc = '🗑️ Delete CodeCompanion Chat' })
  end,
}
