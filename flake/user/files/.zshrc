# -----------------------------
# Paths and Environment
# -----------------------------

source "$HOME/.config/shells/environment.sh"
source "$HOME/.config/shells/functions.sh"
source "$HOME/.config/shells/posix.sh"

# -----------------------------
# Geometry Entry
# -----------------------------
source "$HOME/.config/zsh/geometry/myGeometry.zsh"

# -----------------------------
# Zsh Options
# -----------------------------

# Enable common features
setopt auto_cd           # Automatically `cd` into directories
setopt auto_pushd        # Enable directory stack with `pushd`/`popd`
setopt share_history     # Share command history across Zsh sessions
setopt hist_ignore_dups  # Ignore duplicate commands in history
setopt hist_ignore_space # Ignore commands that start with a space in history
setopt extended_glob     # Enable advanced globbing

# Customize history behavior
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# -----------------------------
# Aliases
# -----------------------------

source "$HOME/.config/shells/aliases.sh"
alias nix="noglob nix"

# -----------------------------
# Plugins and Frameworks
# -----------------------------

if [ -f /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# -----------------------------
# Completion
# -----------------------------

# Load completion system
autoload -Uz compinit
compinit

# Fuzzy search for completions
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ''

# -----------------------------
# Miscellaneous
# -----------------------------

# Prevent duplicate prompt display
export PROMPT_EOL_MARK=""

# Enable vi-mode for the command line
bindkey -v

echo "Welcome to Zsh, $(whoami)@$(hostname)!"

# -----------------------------
# End of File
# -----------------------------
