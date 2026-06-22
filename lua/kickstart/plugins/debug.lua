return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
    'mxsdev/nvim-dap-vscode-js',
    -- 'java-debug-adapter' is explicitly managed by JDTLS, so it's removed here
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F6>',
      function()
        require('dap').terminate()
        require('dapui').close()
      end,
      desc = 'Debug: Stop',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
    {
      '<leader>bb',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Conditional Breakpoint',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Mason-DAP setup
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {
        -- This default_setup handles all Mason-installed DAP servers for which it has defaults.
        -- Java is *not* handled here, as JDTLS will provide it.
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },
      ensure_installed = {
        'delve', -- Go debugger
        'codelldb', -- C/C++/Rust debugger
        'js-debug-adapter', -- JavaScript/TypeScript debugger
        'debugpy', -- Python debugger
        'netcoredbg', -- .NET debugger
        'php-debug-adapter', -- PHP debugger
        'rdbg', -- Ruby debugger
        -- 'java-debug-adapter' is removed from here. JDTLS is responsible for it.
      },
    }

    -- DAP UI setup
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '▶' },
      layouts = {
        {
          elements = {
            { id = 'scopes',      size = 0.40 },
            { id = 'breakpoints', size = 0.15 },
            { id = 'stacks',     size = 0.25 },
            { id = 'watches',    size = 0.20 },
          },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl',    size = 0.5 },
            { id = 'console', size = 0.5 },
          },
          size = 12,
          position = 'bottom',
        },
      },
      floating = { border = 'rounded', mappings = { close = { 'q', '<Esc>' } } },
      render = { max_value_lines = 100 },
    }

    -- Define highlight groups for DAP signs
    vim.api.nvim_set_hl(0, 'DapBreakpointRed',   { ctermbg = 0, fg = '#993939' })
    vim.api.nvim_set_hl(0, 'DapBreakpointGreen', { ctermbg = 0, fg = '#31B53E' })
    vim.api.nvim_set_hl(0, 'DapStoppedGreen',    { ctermbg = 0, fg = '#98c379' })
    -- Full-line background highlight for the line the debugger is currently stopped on
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2a3d2a' }) -- dark green tint

    -- Sign definitions for breakpoints in the Neovim gutter
    vim.fn.sign_define('DapBreakpoint',          { text = '●', texthl = 'DapBreakpointRed',   numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'DapBreakpointRed',   numhl = '' })
    vim.fn.sign_define('DapLogPoint',            { text = '◆', texthl = 'DapBreakpointGreen', numhl = '' })
    -- linehl  = highlights the entire line background when stopped
    -- culhl   = highlights the line when the cursor is on the stopped line (overrides linehl at cursor)
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStoppedGreen', numhl = '', linehl = 'DapStoppedLine', culhl = 'DapStoppedLine' })

    -- Auto open/close DAP UI based on debug events
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Terminate when a step lands in JDK internals (e.g. Thread.exit() after main() returns).
    -- stepFilters only prevent stepping INTO filtered classes; they cannot prevent the JVM's own
    -- thread-lifecycle code from firing a 'stopped' event at Thread.java after main() exits.
    --
    -- How this works without breaking anything:
    --  • 'after' fires AFTER nvim-dap has already processed the event and navigated to the file.
    --  • We check the current buffer name — JDTLS always uses jdt:// URIs for virtual/decompiled
    --    files (Thread.class, etc.). User .java files are opened from disk with real paths.
    --  • We only act when reason == 'step' so intentional JDK breakpoints are never killed.
    --  • vim.schedule() ensures we run in Neovim's main thread (safe for UI calls).
    --  • dap.terminate() is the correct public API — no extra DAP protocol requests needed.
    dap.listeners.after.event_stopped['java_jdk_exit_mark'] = function(session, body)
      if session.config.type == 'java' then
        -- If the reason isn't strictly 'step', we might be missing the exit event!
        if body and (body.reason == 'step' or body.reason == 'exception' or body.reason == 'pause') then
          session.__java_check_jdk_exit = true
        end
      end
    end

    dap.listeners.after.stackTrace['java_jdk_exit'] = function(session, err, response, request)
      if session.config.type ~= 'java' then return end
      if not session.__java_check_jdk_exit then return end
      if err or not response or not response.stackFrames or #response.stackFrames == 0 then return end

      -- Clear the flag so manual stack trace requests don't trigger termination
      session.__java_check_jdk_exit = nil

      vim.schedule(function()
        local top_frame = response.stackFrames[1]
        if top_frame and top_frame.source then
          local source = top_frame.source
          local path = source.path or ''
          
          -- JDTLS internal paths look like: jdt://contents/java.base/java.lang/Thread.class...
          -- All standard JDK modules start with 'java.' or 'jdk.' (e.g., java.base, java.desktop, jdk.compiler)
          local is_jdk_internal = path:find('jdt://contents/java.', 1, true) or 
                                  path:find('jdt://contents/jdk.', 1, true) or
                                  path:find('jdt://contents/sun.', 1, true)

          if is_jdk_internal then
            vim.notify('[DAP] Stepped into JDK internals — terminating session.', vim.log.levels.INFO)
            
            -- Clean up the UI and the virtual buffer
            require('dapui').close()
            local bufnr = vim.api.nvim_get_current_buf()
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:find('jdt://', 1, true) or bufname:find('%3C', 1, true) then
              -- Switch to alternate buffer (the user's code)
              pcall(vim.cmd, 'b#')
              -- Wipeout the virtual buffer to keep the bufferline clean
              pcall(vim.cmd, 'bwipeout! ' .. bufnr)
            end

            dap.terminate()
          end
        end
      end)
    end

    -- Go language specific setup
    require('dap-go').setup {
      delve = { detached = vim.fn.has 'win32' == 0 }, -- Use detached mode for Windows
    }

    -- Python language specific setup
    require('dap-python').setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')

    -- JavaScript/TypeScript language specific setup
    require('dap-vscode-js').setup {
      debugger_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter',
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge' },
    }

    -- JDTLS will automatically register Java DAP configurations via jdtls.dap.setup_dap_main_class_configs()
    -- We provide a manual fallback in case JDTLS fails to auto-discover the main class (e.g., loose files or timeouts)
    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Launch Java App (Manual Fallback)',
        mainClass = function()
          local file_name = vim.fn.fnamemodify(vim.fn.expand '%', ':t:r')
          return vim.fn.input('Main Class: ', file_name)
        end,
        projectName = function()
          return vim.fn.input('Project Name: ', vim.fn.fnamemodify(vim.fn.getcwd(), ':t'))
        end,
        -- Step filters: skip JDK-internal classes when stepping so the debugger
        -- doesn't fall into Thread.java / System.java after your main() exits.
        -- NOTE: The raw java-debug-adapter does NOT support the '$JDK' alias (VSCode-only).
        -- The correct field name is 'classNameFilters', not 'skipClasses'.
        stepFilters = {
          classNameFilters = {
            'java.*',
            'javax.*',
            'jdk.*',
            'sun.*',
            'com.sun.*',
            'org.springframework.*',
          },
          skipSynthetics = true,
          skipStaticInitializers = false,
          skipConstructors = false,
        },
      },
    }

    -- C, C++, Rust (CodeLLDB) configurations
    dap.configurations.cpp = {
      {
        name = 'Launch file (and compile)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local file = vim.fn.expand '%:p'
          -- Corrected function name
          local output = '/tmp/' .. vim.fn.fnamemodify(file, ':t:r') .. '.out'
          local compiler = vim.fn.input('Compiler (e.g., g++): ', 'g++')

          local cmd = string.format('%s -g -o %s %s', compiler, output, file)

          vim.notify('Compiling with: ' .. cmd, vim.log.levels.INFO)
          local success = vim.fn.system(cmd)

          if vim.v.shell_error ~= 0 then
            vim.notify('Compilation failed with errors: ' .. success, vim.log.levels.ERROR)
            return nil
          end

          vim.notify('Compilation successful!', vim.log.levels.INFO)
          return output
        end,
        args = function()
          local args_str = vim.fn.input 'Enter command-line arguments (space-separated): '
          local args = {}
          for arg in args_str:gmatch '%S+' do
            table.insert(args, arg)
          end
          return args
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        externalConsole = true,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end,
}
