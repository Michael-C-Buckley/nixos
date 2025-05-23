# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Starship
eval "$(starship init bash)"
# Transient Prompting
#bleopt prompt_ps1_final='$(starship module character)'
#bleopt prompt_rps1_final='$(starship module time)'

# Bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Nix Profile
if [ -d "$HOME/.nix-profile/bin" ]; then
    export PATH="$HOME/.nix-profile/bin:$HOME/.config/nixpkgs/home/bin:$PATH"
fi

# Shell options
shopt -s cdspell
shopt -s autocd
shopt -s histappend

# Direnv
eval "$(direnv hook bash)"

# Bat replaces Cat if available
if command -v bat >/dev/null 2>&1; then
    alias cat='bat -p'
fi

# FRR
show() {
    sudo vtysh -c "show $*"
}

# Other Files
source "$HOME/.config/shells/environment.sh"
source "$HOME/.config/shells/aliases.sh"

if [ -d ~/.config/shells/bash.d ]; then
  for file in ~/.config/shells/bash.d/*.sh; do
    [ -r "$file" ] && . "$file"
  done
  unset file
fi