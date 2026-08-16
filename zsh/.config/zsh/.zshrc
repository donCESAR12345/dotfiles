# ==============================================================================
# 1. BOOTSTRAP: ZINIT
# ==============================================================================
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

# Install zinit if missing
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# ==============================================================================
# 2. PLUGINS
# ==============================================================================
# Loaded with turbo mode (deferred) to keep startup fast
zinit ice wait'0' lucid; zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait'0' lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait'0' lucid; zinit light Aloxaf/fzf-tab
zinit ice wait'1' lucid; zinit light zsh-users/zsh-completions

# Oh My Zsh snippets
zinit snippet OMZP::git
zinit snippet OMZP::podman
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::archlinux
zinit snippet OMZP::extract
zinit snippet OMZP::command-not-found

# ==============================================================================
# 3. COMPLETION
# ==============================================================================
autoload -Uz compinit; compinit
zinit cdreplay -q  # Replay cached completions from turbo-loaded plugins

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# ==============================================================================
# 4. SHELL OPTIONS
# ==============================================================================
setopt autocd              # cd by typing directory name
setopt correct             # suggest corrections for mistyped commands
setopt nocaseglob          # case-insensitive globbing
setopt notify              # report job status immediately

# History
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# Vi mode (KEYTIMEOUT is set in .zshenv)
bindkey -v

# ==============================================================================
# 5. ALIASES
# ==============================================================================
# Better defaults
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias neofetch='fastfetch'

# Git
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias ga="git add"

# Tools
alias pn="pnpm"
alias zj="zellij"
alias cwd="pwd | wl-copy"

# Config shortcuts
alias ezsh="nvim $ZDOTDIR/.zshrc"
alias esenv="nvim $HOME/.zshenv"

# Firewall
alias fw-status="sudo firewall-cmd --get-active-zones"
alias fw-home="sudo firewall-cmd --set-default-zone=home"
alias fw-public="sudo firewall-cmd --set-default-zone=public"

# Safety nets
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Maintenance
alias tpm-regen="sudo systemd-cryptenroll /dev/nvme0n1p6 --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0,2,4,7,8,9"
alias fix-spotify="sudo chmod a+wr /opt/spotify/; sudo chmod a+wr -R /opt/spotify/Apps/; spicetify backup apply"

# Google Drive sync (rclone)
alias gdrive-status='systemctl --user status rclone-gdrive-bisync.timer'
alias gdrive-log='journalctl --user -u rclone-gdrive-bisync.service -f'
alias gdrive-run='systemctl --user start rclone-gdrive-bisync.service'

# Open nvim with a unique socket (enables remote control)
alias vi='nvim --listen "${XDG_RUNTIME_DIR:-/tmp}/nvim.$RANDOM.0"'
alias vim='vi'

# ==============================================================================
# 6. FUNCTIONS
# ==============================================================================

# Start biblioshiny in a podman container and open it in the browser
bibshiny() {
    local port="${1:-3838}"
    podman container start -i biblioshiny && xdg-open "http://localhost:$port"
}

# AI command assistant — fetches a shell command and loads it into the buffer
# Usage: ask <natural language description>
ask() {
    if [ $# -eq 0 ]; then
        aichat
    else
        local cmd
        cmd=$(aichat --role command "$*" | tr -d '\n' | sed 's/^ *//;s/ *$//')
        print -z "$cmd"
    fi
}

# ==============================================================================
# 7. INITIALIZATIONS
# ==============================================================================
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
