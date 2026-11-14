#!/usr/bin/env bash
set -euo pipefail

# Base directory setup
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION="stow"
TARGET_HOME="$HOME"
SELECTED_MODULES=()
DRY_RUN=""
STOW_IGNORE_ARGS=(
    --ignore='(^|/)README\.md$'
    --ignore='\.example$'
    --ignore='\.bak(\..*)?$'
    --ignore='(^|/)\.env$'
    --ignore='(^|/)\.zcompdump'
    --ignore='(^|/)\.zsh_history$'
)

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { printf "${BLUE}[INFO]${NC} %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$*"; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$*"; }

discover_modules() {
    local modules=()
    local dir name
    for dir in "$DOTFILES_DIR"/*/; do
        [[ -d "$dir" ]] || continue
        name="$(basename "$dir")"
        case "$name" in
            docs|tests|.git) continue ;;
            *) modules+=("$name") ;;
        esac
    done
    printf '%s\n' "${modules[@]}"
}

mapfile -t ALL_MODULES < <(discover_modules)

show_help() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [MODULE...]

Automated dotfiles installation and management script using GNU Stow.

Options:
  -h, --help       Display usage help and exit
  -D, --uninstall  Remove symlinks for all or selected modules
  -n, --dry-run    Simulate actions without modifying files

Available Modules:
  ${ALL_MODULES[*]}

If no positional module arguments are provided, all modules are selected by default.
EOF
}

# Parse CLI arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
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
            show_help
            exit 1
            ;;
        *)
            SELECTED_MODULES+=("$1")
            shift
            ;;
    esac
done

if [[ ${#SELECTED_MODULES[@]} -eq 0 ]]; then
    SELECTED_MODULES=("${ALL_MODULES[@]}")
fi

if ! command -v stow &>/dev/null; then
    error "'stow' command was not found in PATH. Please install GNU Stow."
    exit 1
fi

cd "$DOTFILES_DIR"

# Pre-create XDG target directories so stow links files instead of folding entire trees
info "Preparing target directories in $TARGET_HOME..."
mkdir -p \
    "$TARGET_HOME/.config/systemd/user" \
    "$TARGET_HOME/.config/zsh" \
    "$TARGET_HOME/.local/bin" \
    "$TARGET_HOME/.local/share/applications" \
    "$TARGET_HOME/.local/share/konsole" \
    "$TARGET_HOME/.local/state/zsh" \
    "$TARGET_HOME/.cache/zsh"
ok "Target directories ready."

for module in "${SELECTED_MODULES[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$module" ]]; then
        warn "Module directory '$module' does not exist in $DOTFILES_DIR. Skipping."
        continue
    fi

    if [[ "$ACTION" == "stow" ]]; then
        info "Stowing module: $module"
        if stow $DRY_RUN --no-folding "${STOW_IGNORE_ARGS[@]}" -R -v -t "$TARGET_HOME" "$module"; then
            ok "Stowed $module"
        else
            warn "Failed to stow module '$module'. Check for conflicting existing files in $TARGET_HOME."
        fi
    elif [[ "$ACTION" == "unstow" ]]; then
        info "Unstowing module: $module"
        if stow $DRY_RUN -D -v -t "$TARGET_HOME" "$module"; then
            ok "Unstowed $module"
        else
            warn "Failed to unstow module '$module'."
        fi
    fi
done

if [[ "$ACTION" == "stow" && -z "$DRY_RUN" ]]; then
    info "Executing post-install hooks..."

    if [[ -d "$DOTFILES_DIR/scripts/.local/bin" ]]; then
        chmod +x "$DOTFILES_DIR/scripts/.local/bin/"* 2>/dev/null || true
        ok "Updated permissions for scripts in $DOTFILES_DIR/scripts/.local/bin/"
    fi

    for mod in "${SELECTED_MODULES[@]}"; do
        if [[ "$mod" == "nvim" ]]; then
            if command -v nvim &>/dev/null; then
                info "Syncing Neovim plugins..."
                nvim --headless "+Lazy! sync" +qa || true
                ok "Neovim plugins synchronized."
            else
                warn "Neovim command not found in PATH; skipping plugin sync."
            fi
            break
        fi
    done
fi

ok "All operations completed successfully."
