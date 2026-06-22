-- File: ~/.config/KickstartNvim/lua/kickstart/plugins/indent_line.lua

return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      exclude = {
        filetypes = {
          'dashboard',
          'alpha',
          'starter',
          'NvimTree',
          'neo-tree',
          'help',
          'packer',
          'lspinfo',
          'checkhealth',
          'man',
          'gitcommit',
          'TelescopePrompt',
          'TelescopeResults',
        },
        buftypes = { 'nofile', 'terminal', 'quickfix', 'prompt' },
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
        highlight = 'IblScope', -- This links to the custom highlight group we'll define below
        char = '│',
      },
      -- REMOVED: exclude_modes = { 'c', 'r', 's', 'R', 'S' }, -- This option is not valid
    },
    config = function(_, opts)
      require('ibl').setup(opts)

      -- Define custom highlight groups for indent-blankline
      -- This makes the normal indent lines a subtle gray
      vim.cmd.highlight 'IblIndent1 guifg=#444444'
      vim.cmd.highlight 'IblIndent2 guifg=#444444'
      -- You can add more IblIndentX definitions if you want different shades for deeper indents

      -- Define the custom highlight color for the active indent scope line
      vim.api.nvim_set_hl(0, 'IblScope', {
        fg = '#d67f4a', -- Set the foreground color (the color of the '│' character)
        -- You can also add 'bold = true', 'italic = true', or 'bg = "#your_background_color"'
        -- if you want to highlight the background area of the scope line.
      })

      -- The following lines are no longer needed as IblScope is now directly defined:
      vim.cmd.highlight 'clear @ibl.scope.underline.1'
      vim.cmd.highlight 'link @ibl.scope.underline.1 Visual'
    end,
  },
}
