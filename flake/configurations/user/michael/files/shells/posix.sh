# Posix Shell Items I use
#
# # Bat replaces Cat if available
if command -v bat >/dev/null 2>&1; then
    alias cat='bat -p'
fi

if command -v eza >/dev/null 2>&1; then
    alias ls='eza'
    alias ll='eza -la -g --icons' 
    alias lt='eza --tree --level=2 --icons' 
    alias tree='eza --tree'
fi
