# Posix Shell Items I use
#
# # Bat replaces Cat if available
if command -v bat >/dev/null 2>&1; then
    alias cat='bat -p'
fi
