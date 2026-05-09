# 🛠️ Neovim Configuration

My personal Neovim setup, tailored for my daily workflow on Linux. This configuration focuses on a balance between modern IDE features and the lightweight efficiency of a terminal editor.

## 🚀 Core Utilities
- **Plugin Management:** [lazy.nvim](https://github.com/folke/lazy.nvim)
- **AI-Powered Completion:** [Windsurf](https://github.com/Exafunction/windsurf.vim) integration.
- **Project Management:** [Snacks.nvim](https://github.com/folke/snacks.nvim) for fast project switching and UI utilities.
- **LSP & Tooling:** Automated setup via [Mason](https://github.com/williamboman/mason.nvim) for various languages (Lua, Python, Bash, Terraform, etc.).
- **Fuzzy Finding:** [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for files, symbols, and grep.
- **Aesthetics:** [Catppuccin Mocha](https://github.com/catppuccin/nvim) with transparent background support.

## ⌨️ Essential Keymaps
- `<Leader>p`: Open projects picker (Snacks).
- `<Leader>ff`: Find files (Telescope).
- `<Leader>e`: Toggle file explorer (Neo-tree).
- `<Tab>`: Cycle completion / Accept AI suggestions.

## 📦 Prerequisites
- **Neovim >= 0.10** (Optimized for 0.12+)
- A **Nerd Font** for icons.
- **Mason.nvim** dependencies for language servers and debuggers.
