-- lua/custom/plugins/lsp.lua

return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
      local mason_tool_installer = require 'mason-tool-installer'
      mason_tool_installer.setup {
        ensure_installed = {
          'stylua',
          'java-debug-adapter',
          'java-test',
        },
      }
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
      local mason_lspconfig = require 'mason-lspconfig'

      local servers = {
        html = {},
        cssls = {},
        tailwindcss = {
          filetypes = {
            'html',
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
            'svelte',
          },
        },
        ts_ls = {}, -- Renamed from tsserver
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Register server configs natively for Neovim 0.11+
      for server_name, server_config in pairs(servers) do
        local opts = {
          capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {}),
          settings = server_config.settings,
          filetypes = server_config.filetypes,
          cmd = server_config.cmd,
        }
        
        -- Fallback to old nvim-lspconfig setup if vim.lsp.config doesn't exist (e.g. pre-0.11)
        if vim.lsp.config then
          vim.lsp.config(server_name, opts)
        else
          require('lspconfig')[server_name].setup(opts)
        end
      end

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
      'j-hui/fidget.nvim',
    },
    config = function()
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LspAttach Autocmd for keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', function() require('snacks').picker.lsp_references() end, '[G]oto [R]eferences')
          map('gri', function() require('snacks').picker.lsp_implementations() end, '[G]oto [I]mplementation')
          map('grd', function() require('snacks').picker.lsp_definitions() end, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', function() require('snacks').picker.lsp_symbols() end, 'Open Document Symbols')
          map('gW', function() require('snacks').picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
          map('grt', function() require('snacks').picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local function client_supports_method(c, method, b)
            if vim.fn.has 'nvim-0.11' == 1 then
              return c:supports_method(method, b)
            else
              return c.supports_method(method, { bufnr = b })
            end
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })
    end,
  },

  { 'j-hui/fidget.nvim', opts = {} },
}
