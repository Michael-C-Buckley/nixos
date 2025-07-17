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

# Other Files
source "$HOME/.config/shells/environment.sh"
source "$HOME/.config/shells/aliases.sh"
source "$HOME/.config/shells/functions.sh"
source "$HOME/.config/shells/posix.sh"

if [ -d ~/.config/shells/bash.d ]; then
  for file in ~/.config/shells/bash.d/*.sh; do
    [ -r "$file" ] && . "$file"
  done
  unset file
fi
