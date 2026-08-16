# Modular Dotfiles Restructuring & `install.sh` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure `donCESAR12345/dotfiles` into modular per-tool package directories, implement an automated, idempotent `install.sh` script with post-install hooks, and update `README.md`.

**Architecture:** Each tool configuration resides in a top-level directory (`zsh/`, `nvim/`, `tmux/`, etc.) mirroring the `$HOME` path hierarchy (e.g. `zsh/.config/zsh/`). A central `install.sh` script automates directory pre-creation, Stow symlinking, and Neovim headless plugin synchronization.

**Tech Stack:** GNU Stow, Bash, Zsh, Neovim, Arch Linux / Systemd.

---

### Task 1: Migrate Files into Modular Package Directories

**Files:**
- Create:
  - `archinstall/.config/archinstall/user_configuration.json`
  - `foot/.config/foot/`
  - `nvim/.config/nvim/`
  - `rclone/.config/rclone/`
  - `scripts/.local/bin/keepassxc-prompt`
  - `systemd/.config/systemd/user/`
  - `tmux/.config/tmux/tmux.conf`
  - `zellij/.config/zellij/`
  - `zsh/.config/zsh/`
- Delete: `config/`, `home/`

- [ ] **Step 1: Create top-level module directories**

```bash
mkdir -p archinstall/.config/archinstall \
         foot/.config/foot \
         nvim/.config/nvim \
         rclone/.config/rclone \
         scripts/.local/bin \
         systemd/.config/systemd/user \
         tmux/.config/tmux \
         zellij/.config/zellij \
         zsh/.config/zsh
```

- [ ] **Step 2: Move files into their corresponding module hierarchy**

```bash
# archinstall
cp -r config/archinstall/user_configuration.json archinstall/.config/archinstall/

# foot
cp -r config/foot/* foot/.config/foot/

# nvim
cp -r config/nvim/* nvim/.config/nvim/

# rclone
cp -r config/rclone/* rclone/.config/rclone/

# scripts
cp scripts/keepassxc-prompt scripts/.local/bin/

# systemd
cp -r config/systemd/user/* systemd/.config/systemd/user/

# tmux
cp config/tmux/tmux.conf tmux/.config/tmux/

# zellij
cp -r config/zellij/* zellij/.config/zellij/

# zsh
cp -r config/zsh/* zsh/.config/zsh/
```

- [ ] **Step 3: Remove obsolete `config/` and `home/` directories**

```bash
rm -rf config/ home/
```

- [ ] **Step 4: Verify files are in place**

```bash
ls -d */
```

Expected: `archinstall/`, `docs/`, `foot/`, `nvim/`, `rclone/`, `scripts/`, `systemd/`, `tmux/`, `zellij/`, `zsh/`

- [ ] **Step 5: Commit changes**

```bash
git add -A
git commit -m "refactor: migrate repository structure to modular top-level packages"
```

---

### Task 2: Create `install.sh` Bootstrap Script

**Files:**
- Create: `install.sh`

- [ ] **Step 1: Write `install.sh` script**

Create `install.sh` with the following implementation:

```bash
#!/usr/bin/env bash

# ==============================================================================
# Dotfiles Installation & Management Script
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION="stow"
TARGET_HOME="$HOME"
ALL_MODULES=(archinstall foot nvim rclone scripts systemd tmux zellij zsh)
SELECTED_MODULES=()

# Helper colors
RED='\030[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

usage() {
    echo "Usage: $0 [OPTIONS] [MODULES...]"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -D, --uninstall  Unstow (remove symlinks) specified or all modules"
    echo "  -n, --dry-run    Simulate stow actions without modifying files"
    echo ""
    echo "Available Modules:"
    echo "  ${ALL_MODULES[*]}"
    echo ""
    echo "Examples:"
    echo "  $0                  # Install/restow all modules"
    echo "  $0 zsh nvim         # Install/restow only zsh and nvim"
    echo "  $0 --uninstall zsh  # Unstow zsh module"
    exit 0
}

DRY_RUN=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -D|--uninstall)
            ACTION="unstow"
            shift
            ;;
        -n|--dry-run)
            DRY_RUN="-n"
            shift
            ;;
        -*)
            error "Unknown option: $1"
            ;;
        *)
            SELECTED_MODULES+=("$1")
            shift
            ;;
    esac
done

if ! command -v stow >/dev/null 2>&1; then
    error "GNU Stow is not installed. Please install 'stow' via your package manager."
fi

if [ ${#SELECTED_MODULES[@]} -eq 0 ]; then
    SELECTED_MODULES=("${ALL_MODULES[@]}")
fi

info "Ensuring base target directories exist..."
mkdir -p "$TARGET_HOME/.config" \
         "$TARGET_HOME/.local/bin" \
         "$TARGET_HOME/.local/state/zsh"

cd "$DOTFILES_DIR"

for module in "${SELECTED_MODULES[@]}"; do
    if [ ! -d "$module" ]; then
        warn "Module '$module' not found, skipping."
        continue
    fi

    if [ "$ACTION" == "stow" ]; then
        info "Stowing module: $module"
        stow $DRY_RUN -R -v -t "$TARGET_HOME" "$module" 2>&1 | sed 's/^/  /'
        success "Stowed '$module'"
    else
        info "Unstowing module: $module"
        stow $DRY_RUN -D -v -t "$TARGET_HOME" "$module" 2>&1 | sed 's/^/  /'
        success "Unstowed '$module'"
    fi
done

if [ "$ACTION" == "stow" ] && [ -z "$DRY_RUN" ]; then
    info "Running post-install hooks..."

    # Ensure executable permissions on user scripts
    if [ -d "$DOTFILES_DIR/scripts/.local/bin" ]; then
        chmod +x "$DOTFILES_DIR/scripts/.local/bin/"* 2>/dev/null || true
    fi

    # Sync Neovim plugins if nvim module was installed
    if [[ " ${SELECTED_MODULES[*]} " =~ " nvim " ]] && command -v nvim >/dev/null 2>&1; then
        info "Syncing Neovim plugins desatendidamente..."
        nvim --headless "+Lazy! sync" +qa || warn "Neovim plugin sync returned non-zero exit code."
    fi

    success "Installation complete!"
fi
```

- [ ] **Step 2: Make `install.sh` executable**

```bash
chmod +x install.sh
```

- [ ] **Step 3: Test `install.sh` dry-run**

```bash
./install.sh --dry-run
```

Expected: Stow simulation logs output without errors.

- [ ] **Step 4: Commit `install.sh`**

```bash
git add install.sh
git commit -m "feat: add automated install.sh script with GNU Stow and post-install hooks"
```

---

### Task 3: Update `README.md` Documentation

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update `README.md` with modular architecture & `./install.sh` instructions**

Rewrite `README.md` to reflect:
- New top-level directory layout (`archinstall/`, `foot/`, `nvim/`, `rclone/`, `scripts/`, `systemd/`, `tmux/`, `zellij/`, `zsh/`).
- Quick start instructions using `./install.sh`.
- Manual GNU Stow instructions per module (`stow zsh -t ~`, etc.).
- Reference to `archinstall` OS configuration at `archinstall/.config/archinstall/user_configuration.json`.

- [ ] **Step 2: Commit `README.md`**

```bash
git add README.md
git commit -m "docs: update README.md to document modular structure and install.sh"
```

---

### Task 4: Final Verification

- [ ] **Step 1: Execute `install.sh` dry-run and help test**

```bash
./install.sh --help
./install.sh -n zsh nvim
```

- [ ] **Step 2: Verify git status is clean**

```bash
git status
```

Expected: Clean working tree on branch `main`.
