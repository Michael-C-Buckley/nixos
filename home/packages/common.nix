{pkgs, ...}:
with pkgs; [
  #Editors
  emacs
  
  # Git/Web
  git
  tig
  curl
  wget

  # Shells/Terminals
  zsh
  fish
  nushell
  starship
  pure-prompt # For Zsh

  # Security
  rage
  ragenix
  sops
  ssh-to-pgp
  ssh-to-age

  # Machine Utilities
  python3
  ripgrep
  eza
  duf
  bat
  killall
  du-dust
  atop
  btop
  fd
  fzf
  zoxide
]
