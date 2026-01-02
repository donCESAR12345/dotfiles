# ==============================================================================
# 1. BOOTSTRAP & ENVIRONMENT (ZINIT)
# ==============================================================================
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

# Automatic Zinit installation if not installed
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# ==============================================================================
# 2. PLUGINS (DEFERRED LOAD / TURBO MODE)
# ==============================================================================
# Highlighting and suggestions
zinit ice wait'0' lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait'0' lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait'0' lucid
zinit light Aloxaf/fzf-tab

# Utilities and languages
zinit ice wait'1' lucid
zinit light zsh-users/zsh-completions

# Oh My Zsh snippets
zinit snippet OMZP::git
zinit snippet OMZP::podman
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::archlinux
zinit snippet OMZP::extract
zinit snippet OMZP::command-not-found

# ==============================================================================
# 3. SHELL OPTIONS
# ==============================================================================
autoload -Uz compinit; compinit
zinit cdreplay -q

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

setopt autocd              # Change directory without 'cd'
setopt correct             # Correct commands
setopt nocaseglob          # Ignore case
setopt notify              # Notify jobs status

# History options
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# Vim mode
bindkey -v
export KEYTIMEOUT=1

# ==============================================================================
# 4. COMPLETION STYLE (FZF-TAB)
# ==============================================================================
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# ==============================================================================
# 5. ALIASES
# ==============================================================================
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias vi='nvim'
alias vim='nvim'
alias neofetch='fastfetch'

# Shortcuts
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias ga="git add"
alias pn="pnpm"
alias zj="zellij"
alias cwd="pwd | wl-copy"
alias ezsh="nvim $ZDOTDIR/.zshrc"
alias esenv="nvim $HOME/.zshenv"

# Safety net
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Specific maintenance
alias tpm-regen="sudo systemd-cryptenroll /dev/nvme0n1p6 --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0,2,4,7,8,9"
alias fix-spotify="sudo chmod a+wr /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify; sudo chmod a+wr -R /var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/Apps/; spicetify backup apply"

# ==============================================================================
# 6. CUSTOM FUNCTIONS
# ==============================================================================
# Google Cloud / Jupyter
# gcloud_jupyter_get_ip() {
#     export JUPYTER_CESITAR_IP=$(gcloud compute instances list --project "$GCLOUD_JUPYTER_PROJECT_ID" | awk '/jupyter-cesitar-mega/ { print $5 }')
#     echo $JUPYTER_CESITAR_IP
# }

# Bibshiny
bibshiny() {
    local port="${1:-3838}"
    podman container start -i biblioshiny && xdg-open "http://localhost:$port"
}

# ==============================================================================
# 7. LANGUAGES INIT (CONDA, ETC)
# ==============================================================================
CONDA_PATH="$XDG_DATA_HOME/miniconda3"
if [ -f "$CONDA_PATH/bin/conda" ]; then
    eval "$($CONDA_PATH/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
fi
