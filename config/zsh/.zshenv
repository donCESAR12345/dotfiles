# ==============================================================================
# 1. SYSTEM CORE (XDG & ZDOTDIR)
# ==============================================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
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
# 4. DEVELOPMENT: RUNTIMES & PACKAGES (Rust, Python, Node, Go)
# ==============================================================================
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GOPATH="$XDG_DATA_HOME/go"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export NVM_DIR="$XDG_CONFIG_HOME/nvm"

# ==============================================================================
# 5. DEVELOPMENT: DATA SCIENCE & AI (Python, Jupyter, CUDA)
# ==============================================================================
export CONDA_ENVS="$HOME/.conda/envs"
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
    "$CARGO_HOME/bin"
    "$XDG_DATA_HOME/bin"
    "$HOME/.local/bin"
    "$PYENV_ROOT/bin"
    "$PNPM_HOME"
    "$GOPATH/bin"
    $path
)
fpath=("$XDG_DATA_HOME/zsh/completions" $fpath)

# --- SECRETS ---
[ -f "$ZDOTDIR/.env" ] && source "$ZDOTDIR/.env"
