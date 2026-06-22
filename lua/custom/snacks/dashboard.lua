return {
  {
    'folke/snacks.nvim',
    opts = {
      dashboard = {
        preset = {
          -- CedarVim ASCII art (full, correct version with the ▄▄ top row)
          header = [[
 ██████╗███████╗██████╗  █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
██╔════╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██║   ██║██║████╗ ████║
██║     █████╗  ██║  ██║███████║██████╔╝██║   ██║██║██╔████╔██║
██║     ██╔══╝  ██║  ██║██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╗███████╗██████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],

          -- Keybindings shown by { section = "keys" }
          -- All icons use 4-byte MD Nerd Font codepoints (U+F0000+) which are
          -- reliably stored. 3-byte icons (U+E000-FFFF) get mangled to spaces.
          keys = {
            { icon = '󰈞 ', key = 'f', desc = 'Find File',       action = ":lua Snacks.dashboard.pick('files')" },
            { icon = '󰈔 ', key = 'n', desc = 'New File',        action = ':ene | startinsert' },
            { icon = '󰋚 ', key = 'r', desc = 'Recent Files',    action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = '󰦨 ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒓 ', key = 'c', desc = 'Neovim Config',   action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy',           action = ':Lazy' },
            { icon = '󱁤 ', key = 'm', desc = 'Mason',          action = ':Mason' },
            { icon = '󰗼 ', key = 'q', desc = 'Quit',            action = ':qa' },
          },
        },

        sections = {
          -- ── Left Pane ──────────────────────────────────────────────────────
          { section = 'header' },

          -- Greeting: computed once via IIFE — text field must be a plain string
          {
            align = 'center',
            padding = 1,
            text = (function()
              local hour = tonumber(vim.fn.strftime '%H')
              local part_id = math.floor((hour + 6) / 8) + 1
              local day_part = ({ 'evening', 'morning', 'afternoon', 'evening' })[part_id]
              local username = os.getenv 'USER' or os.getenv 'USERNAME' or 'user'
              return string.format('  Good %s, %s', day_part, username)
            end)(),
          },

          { section = 'keys', gap = 1, padding = 1 },
          { title = 'Recent Projects', section = 'projects', indent = 2, padding = 1 },
          { section = 'startup' },

          -- ── Right Pane (commented out — uncomment to re-enable GitHub integration)
          -- {
          --   pane = 2,
          --   icon = '󰊤 ',
          --   desc = 'Browse CedarVim Repo',
          --   padding = 1,
          --   key = 'b',
          --   action = function()
          --     vim.ui.open 'https://github.com/CralVivy/cedarvim'
          --   end,
          -- },

          -- function()
          --   local in_git = Snacks.git.get_root() ~= nil
          --   local gh_ok = vim.fn.executable 'gh' == 1
          --   local result = {}
          --   -- GitHub Notifications: account-wide, show whenever gh is available
          --   table.insert(result, {
          --     pane = 2, section = 'terminal', enabled = gh_ok,
          --     title = 'Notifications',
          --     cmd = "gh api notifications --paginate --jq '.[:5][] | \"[\\(.reason)] \\(.subject.title)\"'",
          --     action = function() vim.ui.open 'https://github.com/notifications' end,
          --     key = 'n', icon = '󰂚 ', height = 5, padding = 1, ttl = 5 * 60, indent = 3,
          --   })
          --   if in_git then
          --     table.insert(result, {
          --       pane = 2, section = 'terminal', enabled = gh_ok,
          --       title = 'Open Issues', cmd = 'gh issue list -L 3',
          --       action = function() vim.fn.jobstart('gh issue list --web', { detach = true }) end,
          --       key = 'i', icon = '󰌮 ', height = 7, padding = 1, ttl = 5 * 60, indent = 3,
          --     })
          --     table.insert(result, {
          --       pane = 2, section = 'terminal', enabled = gh_ok,
          --       title = 'Open PRs', cmd = 'gh pr list -L 3',
          --       action = function() vim.fn.jobstart('gh pr list --web', { detach = true }) end,
          --       key = 'P', icon = '󰊤 ', height = 7, padding = 1, ttl = 5 * 60, indent = 3,
          --     })
          --     table.insert(result, {
          --       pane = 2, section = 'terminal', enabled = true,
          --       title = 'Git Status', cmd = 'git --no-pager diff --stat -B -M -C',
          --       icon = '󰊢 ', height = 10, padding = 1, ttl = 5 * 60, indent = 3,
          --     })
          --   end
          --   return result
          -- end,
        },
      },
    },
  },
}
