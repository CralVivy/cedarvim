<div align="center">

```
 ██████╗███████╗██████╗  █████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
██╔════╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██║   ██║██║████╗ ████║
██║     █████╗  ██║  ██║███████║██████╔╝██║   ██║██║██╔████╔██║
██║     ██╔══╝  ██║  ██║██╔══██║██╔══██╗╚██╗ ██╔╝██║██║╚██╔╝██║
╚██████╗███████╗██████╔╝██║  ██║██║  ██║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
```

**A high-performance, modular Neovim configuration built for professional developers.**

[![Neovim](https://img.shields.io/badge/Neovim-v0.10+-blueviolet?logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Language-Lua-blue?logo=lua)](https://www.lua.org)
[![Rust Powered](https://img.shields.io/badge/Completion-Rust_Powered-orange?logo=rust)](https://github.com/Saghen/blink.cmp)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE.md)

**Modular • Unified • Low-Latency • Productive**

<!-- SCREENSHOT PLACEHOLDER -->
<!-- Add a high-quality screenshot of CedarVim here -->
<!-- ![CedarVim Dashboard](link_to_screenshot) -->

</div>

---

## What is CedarVim?

CedarVim is a Neovim configuration that builds upon the educational foundation of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and brings it to the level of a full-featured daily driver. Where Kickstart teaches you what every line does, CedarVim has already done the heavy lifting — consolidating plugins, tuning performance, and configuring a complete IDE experience out of the box.

It follows a **Unification Strategy**: instead of installing a plugin for every problem, it consolidates related functionality into single, high-performance engines. Less to maintain. Less memory. More speed.

---

## ✨ Features

- **⚡ Instant Navigation** — A unified, Rust-powered search and picker engine (`snacks.nvim`) handles file finding, live grep, buffer switching, and LSP navigation with sub-millisecond response.
- **🚀 Zero-Lag Autocompletion** — `blink.cmp` provides asynchronous, Rust-based completions with Copilot ghost-text, LuaSnip snippets, and Copilot inline suggestions.
- **🧠 Full LSP Suite** — Automatic server installation and management via Mason. Pre-configured for HTML, CSS, TailwindCSS, TypeScript, and Lua out of the box.
- **🤖 AI Integration** — `CodeCompanion.nvim` provides a persistent, dockable AI chat window and inline refactoring actions. Chat sessions can be saved, loaded, and deleted.
- **🐞 Visual Debugger (DAP)** — A complete debugging interface for **Java, Go, Python, JavaScript/TypeScript, C, and C++** with a visual UI, breakpoints, step-over/into/out, and automatic JDK exit handling.
- **☕ Enterprise Java** — Deep `jdtls` integration with automated workspace management, build-on-attach, test discovery, and a smart DAP session that automatically terminates when your program exits.
- **🚀 Universal Code Runner** — Run any file instantly with `<leader>rr`. Supports Java, Python, C, C++, Go, Rust, JavaScript, TypeScript, Bash, and Lua — zero extra plugins required.
- **🎨 Dynamic Theming** — System-wide color synchronization via `pywal.nvim` with a built-in theme picker. Instantly switch between curated color schemes.
- **📊 Live GitHub Dashboard** — The startup dashboard shows live GitHub notifications, open issues, PRs, and git diff status using the GitHub CLI.
- **🗂 Workspace & Session Management** — Jump between multiple projects instantly. Sessions are automatically saved and restored per-workspace.
- **🖥 Neovide Support** — First-class GUI support with zoom controls (`Ctrl++`, `Ctrl+-`, `Ctrl+0`).

---

## 📦 Dependencies

### Required

These must be installed before running Neovim.

| Dependency | Purpose | Install |
| :--- | :--- | :--- |
| **Neovim** `v0.10+` | The editor itself | [neovim.io](https://neovim.io) |
| **Git** | Plugin management, Gitsigns | System package manager |
| **A Nerd Font** | Icons throughout the UI | [nerdfonts.com](https://www.nerdfonts.com) |
| **ripgrep** (`rg`) | Live grep search in Snacks picker | `sudo dnf install ripgrep` |
| **fd** | Fast file finding | `sudo dnf install fd-find` |
| **Node.js + npm** | Required for many LSP servers | [nodejs.org](https://nodejs.org) |
| **Java JDK 11+** | For Java/JDTLS support | [sdkman.io](https://sdkman.io) |

### Recommended (Optional)

| Dependency | Purpose | Install |
| :--- | :--- | :--- |
| **GitHub CLI** (`gh`) | Live dashboard: notifications, issues, PRs | `sudo dnf install gh` → `gh auth login` |
| **Neovide** | GPU-accelerated GUI frontend | [neovide.dev](https://neovide.dev) |
| **GCC / G++** | C/C++ compilation via code runner | `sudo dnf install gcc g++` |
| **Go** | Go language support + debugger | [go.dev](https://go.dev) |
| **Python 3** | Python debugging via debugpy | System package manager |
| **Rust / cargo** | Rust code runner support | [rustup.rs](https://rustup.rs) |

### Auto-Installed by Mason

When you first open Neovim, `mason.nvim` will automatically install these:

- **LSP Servers:** `html-lsp`, `css-lsp`, `tailwindcss-language-server`, `typescript-language-server`, `lua-language-server`
- **Formatters:** `stylua`
- **Debug Adapters:** `java-debug-adapter`, `java-test`, `codelldb` (C/C++/Rust), `debugpy` (Python)

---

## 🚀 Installation

> **Back up your existing config first!**
> ```bash
> mv ~/.config/nvim ~/.config/nvim.bak
> ```

**1. Clone the repository:**
```bash
git clone https://github.com/CralVivy/cedarvim ~/.config/nvim
```

**2. Launch Neovim:**
```bash
nvim
```
`lazy.nvim` will automatically bootstrap and install all plugins on first launch. This may take a minute.

**3. Authenticate GitHub CLI** *(for live dashboard):*
```bash
gh auth login
```

**4. Done.** Mason will install LSP servers automatically when you first open a supported file type.

---

## 📂 Architecture

CedarVim uses a strict separation of concerns. The `kickstart/` layer provides the stable base; the `custom/` layer is where all CedarVim-specific logic lives.

```
~/.config/nvim/
├── init.lua                    # Core options, keymaps, lazy.nvim bootstrap, Telescope
├── ftplugin/
│   └── java.lua                # JDTLS auto-attach & DAP configuration for Java
└── lua/
    ├── kickstart/plugins/      # Base layer (stable, rarely modified)
    │   ├── debug.lua           # nvim-dap + dapui + all language adapters
    │   ├── gitsigns.lua        # Git hunk signs + inline blame
    │   ├── neo-tree.lua        # File explorer
    │   ├── indent_line.lua     # Indentation guides
    │   ├── lint.lua            # Async linting
    │   └── autopairs.lua       # Auto bracket/quote pairing
    └── custom/                 # CedarVim's core logic layer
        ├── keymaps.lua         # All custom keybindings
        ├── runner.lua          # Universal code runner (10 languages)
        ├── theme_switcher.lua  # Dynamic theme picker
        ├── toggle_buffer.lua   # Buffer management utilities
        ├── utils.lua           # Shared helper functions
        ├── configs/            # Granular plugin-specific settings
        │   └── bufferline.lua
        ├── plugins/            # Plugin specifications
        │   ├── lsp.lua         # Mason + LSP server setup
        │   ├── blink.lua       # blink.cmp + Copilot + LuaSnip
        │   ├── codecompanion.lua # AI chat + inline actions
        │   ├── workspaces.lua  # Project/workspace management
        │   ├── themes.lua      # Color scheme collection
        │   ├── buffer-ui.lua   # Bufferline configuration
        │   └── init.lua        # Misc plugins (toggleterm, pywal, etc.)
        └── snacks/             # Unified snacks.nvim configuration
            ├── dashboard.lua   # Startup dashboard + GitHub integration
            ├── picker.lua      # File/grep/LSP picker setup
            ├── indent.lua      # Indent scope visualization
            └── snacks.lua      # Core snacks module toggles
```

---

## ⌨️ Key Bindings (Quick Reference)

> Leader key: `<Space>`
> Full reference: [`doc/keybinds.md`](doc/keybinds.md)

| Key | Action |
| :--- | :--- |
| `<leader>rr` | **Run current file** (Universal Code Runner) |
| `<leader>f` / `<leader>sf` | Find files |
| `<leader>sg` | Live grep (global search) |
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `<Tab>` / `<S-Tab>` | Next / Previous buffer |
| `<leader>x` | Smart close buffer |
| `<leader>aa` | Toggle AI Chat (CodeCompanion) |
| `<leader>ao` | AI Actions menu |
| `<F5>` | Debug: Start / Continue |
| `<F2>` | Debug: Step Over |
| `<F1>` | Debug: Step Into |
| `<leader>b` | Toggle Breakpoint |
| `<leader>ww` | Switch workspace |
| `<leader>tt` | Open Theme Picker |
| `<C-\>` | Toggle terminal |

---

## 🔌 Plugin Stack

| Category | Plugin | Purpose |
| :--- | :--- | :--- |
| **Package Manager** | `folke/lazy.nvim` | Plugin lifecycle management |
| **UI Hub** | `folke/snacks.nvim` | Dashboard, picker, notifier, indent scope |
| **Completion** | `saghen/blink.cmp` | Async Rust-powered completions |
| **Snippets** | `L3MON4D3/LuaSnip` | Snippet engine |
| **AI** | `olimorris/codecompanion.nvim` | LLM chat + inline actions |
| **AI Ghost Text** | `zbirenbaum/copilot.lua` | Copilot integration |
| **LSP** | `neovim/nvim-lspconfig` | Language server protocol |
| **LSP Install** | `williamboman/mason.nvim` | Automatic LSP/DAP installer |
| **Debugger** | `mfussenegger/nvim-dap` | Debug adapter protocol |
| **Debug UI** | `rcarriga/nvim-dap-ui` | Visual debugger interface |
| **Java** | `mfussenegger/nvim-jdtls` | Enterprise Java IDE features |
| **Git Signs** | `lewis6991/gitsigns.nvim` | Hunk indicators + blame |
| **File Tree** | `nvim-neo-tree/neo-tree.nvim` | File explorer sidebar |
| **Bufferline** | `akinsho/bufferline.nvim` | Buffer/tab bar |
| **Statusline** | `nvim-lualine/lualine.nvim` | Status bar |
| **Terminal** | `akinsho/toggleterm.nvim` | Persistent toggleable terminal |
| **Theming** | `AlphaTechnolog/pywal.nvim` | System-wide color sync |
| **Workspaces** | `natecraddock/workspaces.nvim` | Project management |
| **Treesitter** | `nvim-treesitter/nvim-treesitter` | Syntax highlighting + parsing |
| **Linting** | `mfussenegger/nvim-lint` | Async linting engine |
| **Autopairs** | `windwp/nvim-autopairs` | Smart bracket pairing |

---

## 📖 Documentation

- **[Keybindings Reference](doc/keybinds.md)** — Complete listing of all active keymaps, organized by category.
