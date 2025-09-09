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

    # Networking
    dig
    unixtools.netstat
    unixtools.arp
    ethtool
    inetutils
    iperf3
    net-tools

    # Machine Utilities
    gptfdisk
    parted
    lm_sensors
    usbutils
    pciutils
  ];
}
