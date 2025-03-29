{pkgs, ...}: 
with pkgs; [
  # Git/Web
  git
  tig
  curl
  wget

  # Shells/Terminals
  zsh
  fish
  nushell
  direnv
  blesh # Bash Line Editor - for Starship transient prompt
  starship
  pure-prompt # For Zsh

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