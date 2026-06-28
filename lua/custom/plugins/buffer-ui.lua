-- lua/custom/plugins/ui.lua
return {
  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local function apply_bufferline()
        package.loaded['custom.configs.bufferline'] = nil
        require('bufferline').setup(require('custom.configs.bufferline'))
      end

      apply_bufferline()
      require('custom.toggle_buffer').setup()

      -- Re-apply bufferline highlights every time the colorscheme changes.
      -- This is necessary because bufferline's highlight groups depend on the active
      -- colorscheme and must be regenerated AFTER the ColorScheme event fires.
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('bufferline-reapply', { clear = true }),
        callback = apply_bufferline,
      })
    end,
  },

  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },

  -- Indentline Icons
  { 'nvim-tree/nvim-web-devicons', opts = {} },
}
