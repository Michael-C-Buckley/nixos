{
  lib,
  pkgs,
  self',
  ...
}: {
  packageSets.common = with pkgs; [
    #Editors
    (lib.lowPrio self'.packages.nvf-minimal)

    # Git/Web
    git
    delta
    tig
    curl
    wget
    tree

    # Shells/Terminals
    zsh
    fish
    nushell
    starship
    yazi
    zoxide

    # Machine Utilities
    ethtool
    gparted
    python3
    ripgrep
    eza
    duf
    bat
    killall
    lm_sensors
    du-dust
    atop
    btop
    fd
    fzf
  ];
}
