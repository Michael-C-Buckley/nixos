{
  self,
  pkgs,
  system,
  ...
}:
with pkgs;
  [
    # Git/Web
    gitFull
    lazygit
    delta
    curl
    wget
    tig
    gh

    # Security
    sops

    # Editors
    helix

    # Shells/Terminals
    zsh
    fish
    nushell
    xonsh
    starship
    tmux
    zellij

    # Terminal Utilities
    ripgrep
    eza
    duf
    bat
    vim
    yazi
    zoxide
    du-dust
    btop
    fd
    fzf

    # Nix Tools
    nh
    nix-tree

    # Machine Utilities
    dig
    unixtools.netstat
    unixtools.arp
    ethtool
    gptfdisk
    parted
    lm_sensors
    inetutils
  ]
  ++ [
    self.packages.${system}.ns
  ]
