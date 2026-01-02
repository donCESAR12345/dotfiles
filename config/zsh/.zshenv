# ==============================================================================
# 1. SYSTEM CORE (XDG & ZDOTDIR)
# ==============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ==============================================================================
# 2. USER PREFERENCES (UX & UI)
# ==============================================================================
export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER=less
export BROWSER=google-chrome-stable
export SYSTEMD_EDITOR=$EDITOR

# ==============================================================================
# 3. SHELL OPTIONS
# ==============================================================================
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
export HISTDUP=erase
export KEYTIMEOUT=1 

# ==============================================================================
# 4. DEVELOPMENT: RUNTIMES & PACKAGES
# ==============================================================================
# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# Go
export GOPATH="$XDG_DATA_HOME/go"
# Python
export UV_PYTHON_INSTALL_DIR="$XDG_DATA_HOME/uv/python"
export UV_TOOL_DIR="$XDG_DATA_HOME/uv/tools"
export UV_TOOL_BIN_DIR="$XDG_BIN_HOME"
# Node
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export PNPM_STORE_PATH="$PNPM_HOME/store"
export FNM_DIR="$XDG_DATA_HOME/fnm"
export FNM_MULTISHELL_PATH="$XDG_STATE_HOME/fnm/multishell"
export FNM_LOGLEVEL="error"
export FNM_COREPACK_ENABLED="true"

# ==============================================================================
# 5. DEVELOPMENT: DATA SCIENCE & AI
# ==============================================================================
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export KERAS_HOME="$XDG_STATE_HOME/keras"

# ==============================================================================
# 6. INFRAESTRUCTURE, DOCKER & CLOUD
# ==============================================================================
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export CLOUDSDK_CONFIG="$XDG_CONFIG_HOME/gcloud"
export ANSIBLE_HOME="$XDG_CONFIG_HOME/ansible"

# ==============================================================================
# 7. SYSTEM, COMPILATION & LIBRARIES (C++, Java, Wine)
# ==============================================================================
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Dawt.useSystemAAFontSettings=on"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# ==============================================================================
# 8. PRIVACY, TELEMETRY & NETWORKING
# ==============================================================================
# export DOTNET_CLI_TELEMETRY_OPTOUT=1
# export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
# export NEXT_TELEMETRY_DISABLED=1
# export HOMEBREW_NO_ANALYTICS=1

# ==============================================================================
# 9. DISPLAY & DESKTOP INTEGRATIONS (Wayland, GTK)
# ==============================================================================
export MOZ_ENABLE_WAYLAND=1
export WARP_ENABLE_WAYLAND=1
export GTK_USE_PORTAL=1
export QT_QPA_PLATFORM="wayland;xcb"

# ==============================================================================
# 10. PATH & FPATH CONSTRUCTION
# ==============================================================================
typeset -U path fpath
path=(
    "$XDG_BIN_HOME"
    "$CARGO_HOME/bin"
    "$GOPATH/bin"
    "$PNPM_HOME"
    "$FNM_DIR"
    $path
)
fpath=("$XDG_DATA_HOME/zsh/completions" $fpath)

# --- SECRETS ---
[ -f "$ZDOTDIR/.env" ] && source "$ZDOTDIR/.env"
