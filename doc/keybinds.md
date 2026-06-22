# ⌨️ CedarVim Keybindings Reference

This document provides a comprehensive list of the keybindings actively configured in CedarVim.

## 🧭 General Navigation & Window Management

| Key | Mode | Action |
| :--- | :---: | :--- |
| `<Esc>` | Normal | Clear search highlights (`nohlsearch`) |
| `jj` | Insert | Exit insert mode to Normal mode |
| `Ctrl + Backspace` | Insert | Delete previous word (`<C-w>`) |
| `<C-h/j/k/l>` | Normal | Move window focus (left, down, up, right) |
| `<Esc><Esc>` | Terminal | Exit terminal mode |
| `<leader>q` | Normal | Open diagnostic Quickfix list |

## 📁 Buffers, Files, & Workspaces

| Key | Mode | Action |
| :--- | :---: | :--- |
| `<Tab>` | Normal | Cycle to next buffer |
| `<S-Tab>` | Normal | Cycle to previous buffer |
| `<leader>x` | Normal | Smart close current buffer (preserves layout) |
| `<leader>bn` | Normal | Open a new empty buffer |
| `<leader>e` | Normal | Toggle Neo-tree file explorer |
| `<leader>ww` | Normal | Open workspace switcher (`workspaces.nvim`) |

## 🔍 Searching & Picking (Telescope / Snacks)

| Key | Mode | Action |
| :--- | :---: | :--- |
| `<leader><leader>`| Normal | Find existing buffers |
| `<leader>sf` | Normal | Search Files |
| `<leader>sg` | Normal | Search by Grep (global search) |
| `<leader>sw` | Normal | Search current Word under cursor |
| `<leader>sd` | Normal | Search Diagnostics |
| `<leader>s.` | Normal | Search Recent Files |
| `<leader>sh` | Normal | Search Help tags |
| `<leader>sk` | Normal | Search Keymaps |
| `<leader>sr` | Normal | Resume last search |
| `<leader>/` | Normal | Fuzzily search in current buffer |
| `<leader>s/` | Normal | Search specifically in Open Files |
| `<leader>sn` | Normal | Search Neovim config files |

## 🧠 Code Intelligence (LSP)

| Key | Mode | Action |
| :--- | :---: | :--- |
| `gd` | Normal | Goto Definition |
| `gr` | Normal | Goto References |
| `gI` | Normal | Goto Implementation |
| `gD` | Normal | Goto Declaration |
| `<leader>D` | Normal | Jump to Type Definition |
| `K` | Normal | Hover Documentation |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Code Action (quick fixes, refactoring) |
| `<leader>ds` | Normal | Document Symbols |
| `<leader>ws` | Normal | Workspace Symbols |

## 🤖 AI & CodeCompanion

| Key | Mode | Action |
| :--- | :---: | :--- |
| `<leader>aa` | Normal | Toggle CodeCompanion Chat window |
| `<leader>ao` | Normal | Open CodeCompanion Actions menu |
| `<leader>as` | Normal | Save current CodeCompanion Chat |
| `<leader>al` | Normal | Load a saved CodeCompanion Chat |
| `<leader>ad` | Normal | Delete a saved CodeCompanion Chat |

## 🐞 Debugging (DAP)

| Key | Mode | Action |
| :--- | :---: | :--- |
| `<F5>` | Normal | Start / Continue execution |
| `<F1>` | Normal | Step Into |
| `<F2>` | Normal | Step Over |
| `<F3>` | Normal | Step Out |
| `<leader>b` | Normal | Toggle Breakpoint |
| `<leader>B` | Normal | Set Breakpoint with condition/log message |
| `<F7>` | Normal | Toggle DAP UI |

## 🎨 UI & Aesthetics

| Key | Mode | Action |
| :--- | :---: | :--- |
| `<leader>tt` | Normal | Open Theme Switcher (`pywal` integration) |
| `<C-+>` | Normal/Visual | Zoom In (Neovide scale factor up) |
| `<C-->` | Normal/Visual | Zoom Out (Neovide scale factor down) |
| `<C-0>` | Normal/Visual | Reset Zoom (Neovide scale factor = 1) |
