# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Shell options
shopt -s cdspell
shopt -s autocd
shopt -s histappend

# Direnv
eval "$(direnv hook bash)"

# Other Files
source "$HOME/.config/shells/aliases.sh"
source "$HOME/.config/shells/functions.sh"
source "$HOME/.config/shells/posix.sh"

if [ -d ~/.config/shells/bash.d ]; then
  for file in ~/.config/shells/bash.d/*.sh; do
    [ -r "$file" ] && . "$file"
  done
  unset file
fi
