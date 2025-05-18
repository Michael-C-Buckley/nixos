{
  self,
  config,
  pkgs,
  system,
  ...
}: let
  nvf = self.outputs.packages.${system};
  nvfPkg = "nvf-${config.features.michael.nvf.package}";
in with pkgs; [
  #Editors
  emacs
  nvf.${nvfPkg}

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
  pure-prompt               # For Zsh
  yazi

  # Machine Utilities
  ethtool
  gparted
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
]
