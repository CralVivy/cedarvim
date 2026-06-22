<div align="center">

# 🌲 CedarVim

**A high-performance, modular Neovim configuration engineered for stability and speed.**

[![Neovim](https://img.shields.io/badge/Neovim-v0.10+-blue?logo=neovim&logoColor=white)](https://neovim.io)
[![Language](https://img.shields.io/badge/Language-Lua-blue?logo=lua)](https://www.lua.org)
[![Engine](https://img.shields.io/badge/Engine-Rust--Powered-orange?logo=rust)](https://www.rust-lang.org)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE.md)

---

**Modular • Unified • Low-Latency • Rigorous**

<!-- PLACEHOLDER FOR HERO SCREENSHOT/GIF -->
<!-- Add a high-quality visual of CedarVim in action here -->
<!-- <img src="link_to_screenshot" alt="CedarVim Showcase" width="800"/> -->

</div>

## 📖 Overview

CedarVim is an evolution of the Kickstart.nvim philosophy, optimized for developers who require a professional-grade environment out of the box without the usual bloat. It bridges the gap between an educational starting point and a high-performance daily driver.

By implementing a **Unification Strategy**, CedarVim consolidates redundant plugins into single, high-performance engines, radically reducing cognitive load, configuration complexity, and system memory overhead.

---

## ✨ Features

CedarVim focuses on providing an exceptional, out-of-the-box user experience without sacrificing customizability.

* ⚡ **Lightning-Fast Navigation**
  Navigate your files, search text, and jump to LSP definitions instantly using a unified, Rust-powered picking engine (`snacks.nvim`).
* 🚀 **Zero-Latency Autocompletion**
  Write code without stutter. Experience sub-millisecond autocompletion and inline ghost-text powered by asynchronous tooling (`blink.cmp`).
* 🧠 **Intelligent Development Environment**
  Fully configured LSP integration giving you warnings, formatting, and refactoring tools right away. Includes native AI pairing capabilities for inline chat and code generation (`CodeCompanion`).
* ☕ **Enterprise-Grade Java Support**
  Robust, specialized Java development environment out of the box, complete with proper project loading and debug adapter (`jdtls`) stability.
* 🐞 **Seamless Debugging (DAP)**
  Visually debug your code with a fully integrated interface. Native support and step-filtering for Java, Go, Python, Rust, and C/C++.
* 🎨 **Dynamic, Distraction-Free UI**
  A clean, minimalist interface that puts your code first. Features dynamic system-wide color synchronization (`pywal.nvim`) and precise visual scoping cues.
* 🔄 **Rapid Context Switching**
  Jump between multiple repositories seamlessly with built-in workspace and session management.

---

## 📂 Architecture

The configuration utilizes a strict separation of concerns to ensure stability and make it exceptionally easy for you to maintain and extend.

```text
.
├── init.lua                # Boot sequence, options, and plugin registry
├── lua/
│   ├── custom/             # The core logic layer
│   │   ├── configs/        # Granular plugin settings
│   │   ├── plugins/        # Modular plugin specifications
│   │   ├── snacks/         # Unified picker configurations
│   │   ├── ui/             # UI components and assets
│   │   └── utils/          # Shared helper functions
│   └── kickstart/          # Base foundational components
└── doc/                    # Technical reference (Git-ignored)
```

---

## 📦 Installation

### Prerequisites
- **Neovim**: `v0.10.0+`
- **Font**: A [Nerd Font](https://www.nerdfonts.com/) for proper icon rendering.
- **CLI Tools**: `ripgrep`, `fd`, `npm` (required for fast searching and LSP installation).

### Setup
1. **Clone the repository**:
   Back up any existing Neovim configuration, then clone CedarVim into your config directory:
   ```bash
   git clone https://github.com/CralVivy/cedarvim ~/.config/nvim
   ```
2. **Initialization**:
   Launch Neovim. The package manager (`lazy.nvim`) will automatically bootstrap and install all plugins and dependencies.
3. **Sync & Update**:
   Run `:Lazy update` inside Neovim at any time to synchronize to the latest plugin versions.

---

## 📖 Documentation

Detailed technical references and guides for customizing CedarVim are maintained in the `doc/` directory:

- **[Keybindings Guide](doc/keybinds.md)**: Comprehensive mapping and shortcut reference.
- **[Technical Audit](doc/AUDIT-Rigorous.md)**: Deep-dive analysis of the system architecture.
- **[Implementation Walkthrough](doc/walkthrough.md)**: History of optimizations, migrations, and bug fixes.
