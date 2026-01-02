# 🏗️ Linux Dotfiles — Infrastructure & Development Environment

This repository centralizes my **Linux system configuration**, designed as a reproducible, secure, and developer-focused environment.

The setup follows these core principles:

* **Environment isolation**
* **Declarative configuration via GNU Stow**
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
config/archinstall/user_configuration.json
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
scripts/keepassxc-prompt
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

* **`home/.zshenv`**

  * Global environment variables
  * `PATH` definitions
  * XDG directory locations
  * Always sourced (even in non-interactive shells)

* **`config/zsh/.zshrc`**

  * Interactive configuration
  * Aliases, plugins, completion, prompt

* **`config/zsh/.env`**

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

## 📦 5. Configuration Management (GNU Stow)

All dotfiles are deployed via **symbolic links**, ensuring consistency and reversibility.

### 5.1 Repository Layout

* **`home/`**

  * Files linked directly into `$HOME`
  * Example: `.zshenv`

* **`config/`**

  * Application directories under `~/.config/`
  * Neovim, Zsh, Tmux, Archinstall

* **`scripts/`**

  * Custom user utilities and automation scripts

---

### 5.2 Deployment Commands

From the repository root (`~/dotfiles`):

```bash
# Link home files
stow -t ~ home

# Link application configs
stow -t ~/.config config

# Link user scripts
stow -t ~/.local/bin scripts
```

---

## 🚀 6. Post-Installation Checklist

To replicate this system on new hardware:

1. **Clone the repository**

   ```bash
   git clone https://github.com/donCESAR12345/dotfiles.git ~/dotfiles
   ```

2. **Install the system**

   ```bash
   sudo archinstall --config config/archinstall/user_configuration.json
   ```

3. **Deploy dotfiles**

   * After installation, run the GNU Stow commands listed in section **5.2**
