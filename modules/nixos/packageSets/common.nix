{
  lib,
  pkgs,
  ...
}: {
  packageSets.common = with pkgs; [
    #Editors
    (lib.lowPrio pkgs.nvf-minimal)

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
  ];
}
