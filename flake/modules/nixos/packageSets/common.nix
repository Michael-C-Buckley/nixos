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
    parted
    python3
    lm_sensors
    inetUtils
  ];
}
