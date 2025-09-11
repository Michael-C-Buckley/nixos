# -----------------------------
# Aliases
# -----------------------------

# Common aliases
alias ip='ip --color=auto' # Colorize IP output
alias ll='ls -alF'         # Detailed list with classification
alias la='ls -A'           # List all except `.` and `..`
alias l='ls -CF'           # Simple classified list
alias ..='cd ..'
alias ...='cd ../..'
alias nv='nvim'

# Navigation
alias z='zoxide'

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias ga='git add'
alias gaa='git add *'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gf='git fetch'
alias grv='git remote -v'
alias lg='lazygit'

# Kubernetes
alias k='kubectl'

# Nu/Nushell
alias n='nu -c'

# ZFS
alias zls='zfs list -o name,used,compressratio,lused,avail'
alias zsls='zfs list -t snapshot -S creation -o name,creation,used,written,refer'

# SSH bypass
alias sshn='ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null'

# File Management
alias duz='du -xh . | sort -hr | fzf'

