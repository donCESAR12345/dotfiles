# Bootstrap XDG paths and delegate full environment configuration to $ZDOTDIR/.zshenv.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

[ -f "$ZDOTDIR/.zshenv" ] && source "$ZDOTDIR/.zshenv"
