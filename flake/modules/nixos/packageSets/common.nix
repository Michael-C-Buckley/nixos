{pkgs, ...}: {
  packageSets.common = with pkgs; [
    # Git/Web
    gitFull
    lazygit
    delta
    curl
    wget

    # Shells/Terminals
    zsh
    fish
    nushell
    xonsh
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
    inetutils
  ];
}
