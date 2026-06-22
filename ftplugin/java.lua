local jdtls = require 'jdtls'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name

local mason_registry = require 'mason-registry'
local jdtls_pkg = mason_registry.get_package 'jdtls'
local jdtls_path = jdtls_pkg:get_install_path()

-- Load Java DAP bundles
local java_debug_pkg = mason_registry.get_package 'java-debug-adapter'
local java_debug_path = java_debug_pkg:get_install_path()
local java_test_pkg = mason_registry.get_package 'java-test'
local java_test_path = java_test_pkg:get_install_path()

local bundles = {}
vim.list_extend(bundles, vim.split(vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n'))
vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar'), '\n'))

local os_config = 'linux'
if vim.fn.has 'mac' == 1 then
  os_config = 'mac'
end

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    jdtls_path .. '/config_' .. os_config,
    '-data',
    workspace_dir,
  },

  root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

  settings = {
    java = {
      home = vim.fn.expand('~/.sdkman/candidates/java/current'),
      eclipse = { downloadSources = true },
      configuration = { 
        updateBuildConfiguration = 'interactive',
        runtimes = {
          {
            name = "JavaSE-21",
            path = vim.fn.expand('~/.sdkman/candidates/java/current'),
            default = true,
          }
        }
      },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      format = { enabled = true },
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
    },
    contentProvider = { preferred = 'fernflower' },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  },

  init_options = {
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },

  on_attach = function(client, bufnr)
    -- config_overrides are merged into EVERY auto-generated JDTLS launch config via
    -- make_config() → vim.tbl_extend('force', config, config_overrides).
    -- This is the only correct way to inject stepFilters into JDTLS-discovered configs.
    -- Without this, stepFilters only exist on the manual fallback and are ignored when
    -- JDTLS auto-discovers the main class (which overwrites dap.configurations.java).
    jdtls.setup_dap {
      hotcodereplace = 'auto',
      config_overrides = {
        -- classNameFilters: the java-debug-adapter skips these packages during step operations.
        -- When stepping over the last } of main(), the JVM would go to Thread.exit() —
        -- with 'java.*' filtered, the adapter auto-continues past it until exit.
        stepFilters = {
          classNameFilters = {
            'java.*',
            'javax.*',
            'jdk.*',
            'sun.*',
            'com.sun.*',
          },
          skipSynthetics = true,
          skipStaticInitializers = false,
          skipConstructors = false,
        },
      },
    }
    require('jdtls.dap').setup_dap_main_class_configs()
  end,
  
  capabilities = require('blink.cmp').get_lsp_capabilities(),
}

require('jdtls').start_or_attach(config)

vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = 'Organize Imports' })
vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = 'Extract Variable' })
vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = 'Extract Method' })
