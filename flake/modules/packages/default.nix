# I split packages into groups based on usage then enable as needed
# They are also generally only added to the paths of users who needs them as well
{pkgs, ...}: let
  commonPkgs = with pkgs; [
    # System
    fastfetch
    microfetch
    killall

    # Shells (Zsh defined on its own)
    nushell
    tmux
    starship
    comma

    # Development/Management
    python3
    git
    tig

    # File/Navigation
    lsd
    eza
    fd
    du-dust
    fzf
    zoxide
    bat
    ripgrep
    wget
    zip

    # Performance
    atop
    btop
    htop

    # Hardware
    usbutils
    pciutils
    smartmontools
    lm_sensors

    # Network
    nmap
    iperf
    tcpdump
    inetutils
    frr
    wireguard-tools
    dig
    ethtool
    vlan
    bridge-utils
    lldpd
    cdpr
    ndisc6
    net-tools
  ];
in {
  imports = [
    ./fonts.nix
  ];

  users.users = {
    michael.packages = commonPkgs;
    root.packages = commonPkgs;
    shawn.packages = commonPkgs;
  };
}
