{
  customPkgs,
  pkgs,
  ...
}:
with pkgs;
  [
    # Git/Web
    gitFull
    lazygit
    difftastic
    curl
    wget
    tig
    gh
    jujutsu

    # Security
    sops

    # Shells/Terminals
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
    customPkgs.ns
  ]
