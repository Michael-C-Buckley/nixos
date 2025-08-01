# -----------------------------
# Paths and Environment
# -----------------------------

# Set the default editor
export VISUAL="vim"
export EDITOR=$VISUAL
export GIT_EDITOR=$VISUAL
export PAGER="bat"
export MANPAGER="bat -l man -p"
export BROWSER=librewolf
export DIFF=diff-so-fancy

# Enable color in `ls` and other commands
export CLICOLOR=1
export LSCOLORS="auto"
export DIFF_COLOR=auto
export IP_COLOR=always

# Some specific things
export NIXOS_OZONE_WL=1
export GTK_USE_PORTAL=1
export NH_FLAKE=/home/michael/nixos
