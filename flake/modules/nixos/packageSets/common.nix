{pkgs, ...}: {
  packageSets.common = with pkgs; [
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

    # Terminal Utilities
    ripgrep
    eza
    duf
    bat
    tree
    vim
    yazi
    zoxide
    du-dust
    btop
    fd
    fzf

    # Machine Utilities
    ethtool
    gptfdisk
    python3
    lm_sensors
  ];
}
