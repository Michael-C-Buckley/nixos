{
  pkgs,
  inputs,
  system,
  ...
}:
with pkgs; [
  #Editors
  emacs
  inputs.michael-nvf.packages.${system}.default

  # Git/Web
  git
  delta
  tig
  curl
  wget

  # Shells/Terminals
  zsh
  fish
  nushell
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
