# 📐 Design Spec: Modular Dotfiles Restructuring & Automated `install.sh`

**Date:** 2026-08-16  
**Status:** Approved  
**Author:** AGY Pair Programmer  

---

## 1. Overview & Goals

This spec defines the migration of the `donCESAR12345/dotfiles` repository from a destination-based layout (`config/`, `home/`, `scripts/`) to a **modular, per-tool package architecture** inspired by [`xero/dotfiles`](https://github.com/xero/dotfiles).

### Core Objectives:
1. **Per-Tool Modularity:** Reorganize configuration into independent top-level package directories (`zsh/`, `nvim/`, `tmux/`, `zellij/`, `foot/`, `rclone/`, `systemd/`, `scripts/`, `archinstall/`).
2. **Strict Clean `$HOME` Compliance:** Keep `$HOME` free of loose dotfiles. All shell configuration (including Zsh `.zshenv`, `.zshrc`, `.env`) resides strictly under `.config/zsh/`.
3. **Automated Bootstrap Script (`install.sh`):** Provide an idempotent, flexible Bash installation script supporting selective module stowage, dry-runs, uninstallation, and post-install hooks (e.g. Neovim headless plugin sync).
4. **Updated Documentation (`README.md`):** Reflect the modular architecture, usage of `install.sh`, and system deployment steps.

---

## 2. Directory Architecture

Every tool module mirrors the path structure relative to `$HOME`. A single command `stow <module> -t ~` links any module seamlessly.

```text
dotfiles/
├── archinstall/
│   └── .config/
│       └── archinstall/
│           └── user_configuration.json
├── foot/
│   └── .config/
│       └── foot/
│           ├── dank-colors.ini
│           ├── foot.ini
│           └── themes/
├── nvim/
│   └── .config/
│       └── nvim/
│           ├── init.lua
│           ├── lazy-lock.json
│           ├── README.md
│           └── lua/
├── rclone/
│   └── .config/
│       └── rclone/
│           ├── filters.txt
│           └── sync-gdrive-example.env
├── scripts/
│   └── .local/
│       └── bin/
│           └── keepassxc-prompt
├── systemd/
│   └── .config/
│       └── systemd/
│           └── user/
│               ├── discord-rpc-extension.service
│               ├── notify-failed@.service
│               ├── rclone-bisync@.service
│               └── rclone-bisync@.timer
├── tmux/
│   └── .config/
│       └── tmux/
│           └── tmux.conf
├── zellij/
│   └── .config/
│       └── zellij/
│           ├── config.kdl
│           └── config.kdl.bak
├── zsh/
│   └── .config/
│       └── zsh/
│           ├── .env
│           ├── .zshenv
│           └── .zshrc
├── docs/
│   └── superpowers/
│       └── specs/
├── install.sh
├── LICENSE
├── README.md
└── .gitignore
```

---

## 3. Specification for `install.sh`

### 3.1 Script Behavior & CLI Interface

- **Default Execution (`./install.sh`):** Pre-creates directories, stows **all** available modules, and runs post-install hooks.
- **Selective Execution (`./install.sh zsh nvim tmux`):** Stows only the specified modules.
- **Uninstall Mode (`./install.sh --uninstall` or `./install.sh -D [modules]`):** Unstows modules using `stow -D`.
- **Help Flag (`./install.sh --help` or `-h`):** Prints a clear help message listing available modules and options.

### 3.2 Pre-requisites & Checks

1. Check for `stow` binary in `$PATH`. Fail gracefully with an informative error if missing.
2. Ensure target directories exist before running `stow` to prevent Stow from creating directory symlinks instead of folding files into existing directories:
   - `~/.config`
   - `~/.local/bin`
   - `~/.local/state/zsh`

### 3.3 Stow Execution

- Use `stow -R -t ~ <module>` (Restow mode) for idempotent linking without conflicts when re-running `install.sh`.
- Print status indicators for each module (e.g. `[OK] Stowed zsh`).

### 3.4 Post-Install Hooks

After successful stowage:
1. Ensure executable permissions on user scripts: `chmod +x ~/.local/bin/*` (or `scripts/.local/bin/*`).
2. Sincronize Neovim plugins desatendidamente if `nvim` module is installed and `nvim` binary exists:
   ```bash
   nvim --headless "+Lazy! sync" +qa
   ```

---

## 4. Documentation Updates (`README.md`)

Update `README.md` to:
- Document the new modular directory tree.
- Explain usage of `./install.sh` (all vs selective packages).
- Update Stow manual commands to reference module names (`stow zsh -t ~`, `stow nvim -t ~`, etc.).
- Maintain `archinstall` OS deployment instructions clearly referenced at `archinstall/.config/archinstall/user_configuration.json`.

---

## 5. Verification & Testing Plan

1. **Structure Integrity Check:** Verify all files from `config/`, `home/`, and `scripts/` are correctly moved to their new modular locations without data loss.
2. **Stow Dry-Run Test:** Test `./install.sh` and verify symlinks under `~/.config/` and `~/.local/bin/` point accurately to `~/dotfiles/<module>/...`.
3. **Neovim Headless Test:** Confirm `nvim --headless "+Lazy! sync" +qa` completes cleanly.
