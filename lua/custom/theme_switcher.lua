local m = {}

local theme_file = vim.fn.stdpath('config') .. '/lua/custom/current_theme.lua'

local themes = {
  'catppuccin',
  'tokyonight',
  'onedark',
  'tokyodark',
  'nightfox',
  'nord',
  'rose-pine',
  'kanagawa',
  'material',
  'oxocarbon',
  'github_dark',
  'github_light',
  'github_dark_default',
  'github_light_default',
  'everforest',
  'gruvbox-material',
  'gruvbox',
  'gruvbox-baby',
  'zenbones',
  'minimal',
  'ayu',
  'onedarkpro',
  'vscode',
  'monokai-pro',
  'fluoromachine',
  'juliana',
  'bamboo',
  'no-clown-fiesta',
  'visual_studio_code',
  'tender',
  'night-owl',
}

local function save_theme(mode, theme)
  local file = io.open(theme_file, 'w')
  if file then
    local content = string.format('return { mode = "%s", theme = "%s" }\n', mode, theme)
    file:write(content)
    file:close()
  else
    vim.notify('Error saving theme!', vim.log.levels.ERROR)
  end
end

local function restore_ui_defaults()
  -- Bufferline re-applies itself via a ColorScheme autocmd registered in buffer-ui.lua.
  -- No manual re-setup needed here.
end

function m.load_last_theme()
  local ok, data = pcall(dofile, theme_file)
  if not ok then
    vim.cmd 'colorscheme default'
    return
  end

  local mode, theme
  if type(data) == 'table' then
    mode = data.mode
    theme = data.theme
  else
    mode = 'static'
    theme = data
  end

  if mode == 'dynamic' then
    vim.cmd 'colorscheme pywal'
  elseif theme and theme ~= '' then
    vim.cmd('colorscheme ' .. theme)
  else
    vim.cmd 'colorscheme default'
  end

  restore_ui_defaults()
end

m.load_theme = function(theme)
  local mode = 'static'
  local theme_to_save = theme
  if theme == '🌈 Pywal (Dynamic)' then
    mode = 'dynamic'
    theme_to_save = 'pywal'
    vim.cmd 'colorscheme pywal'
  else
    vim.cmd('colorscheme ' .. theme)
  end

  vim.notify('Loaded ' .. mode .. ' theme: ' .. theme, vim.log.levels.INFO, { title = 'Theme Switcher' })
  save_theme(mode, theme_to_save)
  restore_ui_defaults()
end

m.pick_theme = function()
  local options = { '🌈 Pywal (Dynamic)' }
  for _, v in ipairs(themes) do
    table.insert(options, v)
  end

  require('snacks').picker.select(options, {
    prompt = 'Select Theme Mode',
  }, function(item)
    if item then
      m.load_theme(item)
    end
  end)
end

return m
