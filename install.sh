#!/usr/bin/env bash
set -euo pipefail

# Base directory setup
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION="stow"
TARGET_HOME="$HOME"
SELECTED_MODULES=()
STOW_DRY_RUN=()
FAILED_MODULES=()
STOW_IGNORE_ARGS=(
    --ignore='(^|/)README\.md$'
    --ignore='\.example$'
    --ignore='-example\.env$'
    --ignore='\.bak(\..*)?$'
    --ignore='\.zwc$'
    --ignore='(^|/)\.env$'
    --ignore='(^|/)sync-.*\.env$'
    --ignore='(^|/)config\.local$'
    --ignore='(^|/)user_preferences\.json$'
    --ignore='(^|/)\.stow-local-ignore$'
    --ignore='(^|/)\.zcompdump'
    --ignore='(^|/)\.zsh_history$'
)

# Color definitions for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { printf '%b[INFO]%b %s\n' "$BLUE" "$NC" "$*"; }
ok()    { printf '%b[OK]%b %s\n' "$GREEN" "$NC" "$*"; }
warn()  { printf '%b[WARN]%b %s\n' "$YELLOW" "$NC" "$*"; }
error() { printf '%b[ERROR]%b %s\n' "$RED" "$NC" "$*"; }

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
    if [[ ${#modules[@]} -gt 0 ]]; then
        printf '%s\n' "${modules[@]}"
    fi
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
            STOW_DRY_RUN=(-n)
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
if [[ "$ACTION" == "stow" && ${#STOW_DRY_RUN[@]} -eq 0 ]]; then
    info "Preparing target directories in $TARGET_HOME..."
    mkdir -p \
        "$TARGET_HOME/.config/DankMaterialShell" \
        "$TARGET_HOME/.config/environment.d" \
        "$TARGET_HOME/.config/hypr/dms" \
        "$TARGET_HOME/.config/systemd/user" \
        "$TARGET_HOME/.config/zsh" \
        "$TARGET_HOME/.local/bin" \
        "$TARGET_HOME/.local/share/applications" \
        "$TARGET_HOME/.local/share/konsole" \
        "$TARGET_HOME/.local/state/zsh" \
        "$TARGET_HOME/.cache/zsh"
    ok "Target directories ready."
fi

for module in "${SELECTED_MODULES[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$module" ]]; then
        warn "Module directory '$module' does not exist in $DOTFILES_DIR. Skipping."
        FAILED_MODULES+=("$module")
        continue
    fi

    if [[ "$ACTION" == "stow" ]]; then
        info "Stowing module: $module"
        if stow "${STOW_DRY_RUN[@]}" --no-folding "${STOW_IGNORE_ARGS[@]}" -R -v -t "$TARGET_HOME" "$module"; then
            ok "Stowed $module"
        else
            warn "Failed to stow module '$module'. Check for conflicting existing files in $TARGET_HOME."
            FAILED_MODULES+=("$module")
        fi
    elif [[ "$ACTION" == "unstow" ]]; then
        info "Unstowing module: $module"
        if stow "${STOW_DRY_RUN[@]}" -D -v -t "$TARGET_HOME" "$module"; then
            ok "Unstowed $module"
        else
            warn "Failed to unstow module '$module'."
            FAILED_MODULES+=("$module")
        fi
    fi
done

if [[ "$ACTION" == "stow" && ${#STOW_DRY_RUN[@]} -eq 0 ]]; then
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

if [[ ${#FAILED_MODULES[@]} -gt 0 ]]; then
    error "Completed with failures in modules: ${FAILED_MODULES[*]}"
    exit 1
fi

ok "All operations completed successfully."
