{pkgs, ...}: {
  packageSets.common = with pkgs; [
    # Git/Web
    gitFull
    lazygit
    delta
    curl
    wget

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

    # Machine Utilities
    dig
    unixtools.netstat
    unixtools.arp
    ethtool
    gptfdisk
    parted
    lm_sensors
    inetutils
  ];
}
