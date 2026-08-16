# 🏗️ Linux Dotfiles — Infrastructure & Development Environment

This repository centralizes my **Linux system configuration**, designed as a reproducible, secure, and developer-focused environment.

The setup follows these core principles:

* **Environment isolation**
* **Declarative configuration via GNU Stow**
* **Modular package architecture**
* **Automation-first mindset**
* **Modern CLI tooling**, largely based on Rust

While the current implementation targets **Arch Linux**, the structure and philosophy are **distribution-agnostic** and intended to support additional distributions (e.g. Fedora, Ubuntu) in the future.

---

## 📌 Repository Goals

* Provide a **clean and reproducible Linux setup**
* Keep configuration **modular and version-controlled**
* Minimize global dependencies
* Deliver a **fast, keyboard-driven CLI and IDE-like experience**

---

## 🛠️ 1. Base System Installation (Current: Arch Linux)

This section documents the deployment of the operating system using the official guided installer, applying a custom configuration focused on security, performance, and developer ergonomics.

### 1.1 Deployment Method: Archinstall

The system is deployed using the official [`archinstall`](https://wiki.archlinux.org/title/Archinstall) tool.
The configuration file is located at:

```
archinstall/.config/archinstall/user_configuration.json
```

**Key configuration details:**

* **Boot & Security**

  * **UKI (Unified Kernel Images)** enabled
    Combines kernel, initramfs, and kernel command line into a single EFI binary, simplifying **Secure Boot** implementation.

* **Memory Management**

  * **ZRAM-based swap** using `zstd` compression
    Improves responsiveness under memory pressure before hitting disk.

* **Application Stack**

  * **Power Management:** `power-profiles-daemon`
  * **Peripherals:** Bluetooth and printing services (CUPS) enabled at install time

* **Core Toolset**

  * **Shell & Multiplexing:** `zsh`, `tmux`, `starship`
  * **Modern CLI (Rust-based):** `eza`, `bat`, `ripgrep`, `fd`, `zoxide`, `dust`
  * **Development & Build Tools:** `uv`, `stow`, `neovim`, `base-devel`

---

### 1.2 Storage Layout (BTRFS + LUKS)

Although the installation is automated, a custom and resilient storage layout is defined:

* **Encryption:** LUKS2 via `dm-crypt`
* **Filesystem:** BTRFS
* **Subvolumes:**

  * `/@` — Root filesystem
  * `/@home` — User data
  * `/@snapshots` — System recovery and snapshots

---

### 1.3 Dual Boot & Firmware

* **Windows 11**

  * Coexists via `systemd-boot`
  * Windows EFI entry manually registered in the Linux ESP

* **Secure Boot**

  * Implemented post-installation using `sbctl`
  * All generated binaries are properly signed

---

## 🔐 2. Secrets Management & Authentication

This setup focuses on **strong identity management** while maintaining a smooth developer experience.

### 2.1 Identity Architecture: KeePassXC + OpenSSH

SSH key handling is designed to keep secrets **encrypted and ephemeral**:

* **Private Keys**

  * Stored on disk
  * Always protected by a passphrase

* **SSH Agent Provider**

  * KeePassXC acts as the SSH agent socket
  * Communicates via the native OpenSSH protocol

---

### 2.2 Automation via `ProxyCommand`

To avoid manual key loading and authentication errors, a wrapper script is used:

```
scripts/.local/bin/keepassxc-prompt
```

**Execution flow:**

* `~/.ssh/config` uses the `ProxyCommand` directive
* On every SSH connection attempt (e.g. `git push`):

  1. If `ssh-add -l` returns identities → connection proceeds
  2. If the agent is empty:

     * KeePassXC is brought to the foreground
     * Network connection pauses until the database is unlocked

**Result:**

* No `Permission denied (publickey)` errors
* No manual `ssh-add` on session start
* Strong security without UX friction

---

### 2.3 Git Commit Signing

* All Git operations are tied to this authentication flow
* Ensures every commit in this dotfiles repository is:

  * Authenticated
  * Traceable
  * Bound to the current hardware identity

---

## 🐚 3. Shell Configuration (Zsh)

Zsh is fully modularized and compliant with the **XDG Base Directory Specification**, ensuring fast startup and clean separation of concerns.

### 3.1 File Structure

* **`zsh/.config/zsh/.zshenv`**

  * Global environment variables
  * `PATH` definitions
  * XDG directory locations
  * Sourced for environment setup

* **`zsh/.config/zsh/.zshrc`**

  * Interactive configuration
  * Aliases, plugins, completion, prompt

* **`zsh/.config/zsh/.env`**

  * Sensitive environment variables
  * Loaded at the very end of `.zshrc`

---

### 3.2 Tool Integration

`.zshrc` orchestrates all modern CLI tools:

* **Prompt:** `starship`
* **Smart Navigation:** `zoxide`
* **Syntax & UX:** Rust-based replacements (`eza`, `bat`, `fd`) via aliases

---

## ⌨️ 4. Text Editor — Neovim (IDE-like Setup)

Neovim is configured as a **modular, high-performance IDE**, optimized for Python and web development.

### 4.1 Plugin Architecture

* **Plugin Manager:** `lazy.nvim`

  * Lazy loading ensures startup times below **50ms**

* **Binary & Tool Isolation:** `mason.nvim`

  * LSPs, linters, and formatters installed in:

    ```
    ~/.local/share/nvim/mason
    ```
  * No global system dependencies required

---

### 4.2 Code Intelligence & Development

* **LSP & Completion**

  * `nvim-lspconfig`
  * `nvim-cmp`
  * Completion sources:

    * Native LSP
    * Snippets (`LuaSnip`)
    * File paths
    * **Codeium** (AI assistant)

* **Strict Formatting**

  * Managed by `conform.nvim`
  * Tooling:

    * Python: `ruff`, `black`
    * Frontend: `prettierd`
    * Lua: `stylua`

* **Debugging & Testing**

  * `nvim-dap` for step-by-step debugging
  * `neotest` for running unit tests directly from buffers

---

### 4.3 UI & Navigation

* **Theme:** `tokyonight.nvim`

  * Automatic light/dark mode switching based on system state

* **Navigation**

  * `telescope.nvim` (fuzzy finder)
  * `neo-tree.nvim` (file explorer)

* **Productivity**

  * `which-key.nvim` for keybinding discovery
  * `neogit` for fast, integrated Git workflows

---

## ⚡ 5. Fast Automated Installation

The repository includes an automated management script `./install.sh` built around GNU Stow. It handles directory preparation, module deployment, script permissions, and plugin synchronization automatically.

### 5.1 Usage Examples

```bash
# Install / stow all modules
./install.sh

# Selective installation of specific modules (e.g. zsh and nvim)
./install.sh zsh nvim

# Simulate deployment without modifying any files (dry-run)
./install.sh --dry-run
# or
./install.sh -n

# Unstow / remove symlinks for all or selected modules
./install.sh --uninstall
# or
./install.sh -D zsh nvim
```

### 5.2 What `install.sh` Does Automatically

1. **Target Directory Setup:** Pre-creates essential target directories inside `$HOME` (`.config`, `.local/bin`, `.local/state/zsh`).
2. **Modular Stow:** Executes GNU Stow (`stow -R -v -t ~ <module>`) to link package files into your target home directory.
3. **Script Permissions:** Ensures custom user binaries in `scripts/.local/bin/` are executable (`chmod +x`).
4. **Plugin Sync:** Headlessly synchronizes Neovim plugins via `lazy.nvim` (`nvim --headless "+Lazy! sync" +qa`) when the `nvim` module is selected.

---

## 📦 6. Configuration Management (GNU Stow)

All dotfiles are structured into top-level package directories and deployed via **symbolic links** mapping directly to target locations inside `$HOME`.

### 6.1 Repository Layout

Each top-level directory represents an independent, modular package:

```
dotfiles/
├── archinstall/    # Archinstall configuration (~/.config/archinstall/user_configuration.json)
├── foot/           # Foot terminal emulator config (~/.config/foot/)
├── nvim/           # Neovim IDE configuration (~/.config/nvim/)
├── rclone/         # Rclone sync configuration (~/.config/rclone/)
├── scripts/        # User binaries & automation (~/.local/bin/)
├── systemd/        # User systemd services & timers (~/.config/systemd/user/)
├── tmux/           # Tmux terminal multiplexer config (~/.config/tmux/)
├── zellij/         # Zellij terminal workspace config (~/.config/zellij/)
└── zsh/            # Zsh shell configuration (~/.config/zsh/)
```

### 6.2 Manual GNU Stow Commands

If you prefer to manage symlinks manually without using `./install.sh`, you can invoke `stow` directly from the repository root:

```bash
# Stow individual modules into $HOME
stow zsh -t ~
stow nvim -t ~
stow scripts -t ~

# Stow all package modules at once
stow archinstall foot nvim rclone scripts systemd tmux zellij zsh -t ~

# Restow (refresh links) for specific modules
stow -R zsh nvim -t ~

# Unstow / remove symlinks for a module
stow -D zsh -t ~
```

---

## 🚀 7. Post-Installation Checklist

To replicate this system on new hardware:

1. **Clone the repository**

   ```bash
   git clone https://github.com/donCESAR12345/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Install the system (optional Arch Linux deployment)**

   ```bash
   sudo archinstall --config archinstall/.config/archinstall/user_configuration.json
   ```

3. **Deploy dotfiles**

   * Run the automated installation script:
     ```bash
     ./install.sh
     ```
   * Or use manual GNU Stow commands as described in section **6.2**.
