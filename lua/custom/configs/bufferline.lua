return {
  options = {
    numbers = 'none',
    close_command = 'bdelete! %d',
    right_mouse_command = 'bdelete! %d',
    left_mouse_command = 'buffer %d',
    middle_mouse_command = nil,
    indicator = { icon = '▎', style = 'icon' },
    buffer_close_icon = '󰅖',
    modified_icon = '●',
    separator_style = 'slant',
    always_show_bufferline = true,
    show_buffer_icons = true,
    show_close_icon = false,
    show_buffer_close_icons = false,
    show_tab_indicators = true,
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, _, diag)
      local icons = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
      local ret = ''
      for name, count in pairs(diag) do
        if icons[name] and count > 0 then
          ret = ret .. icons[name] .. count .. ' '
        end
      end
      return ret
    end,
    offsets = {
      {
        filetype = 'neo-tree',
        text = 'Neo Tree',
        highlight = 'Directory',
        separator = true,
      },
    },
    sort_by = 'insert_at_end',
  },
}
