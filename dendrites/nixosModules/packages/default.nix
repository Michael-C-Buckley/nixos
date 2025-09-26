# I split packages into groups based on usage then enable as needed
# They are also generally only added to the paths of users who needs them as well
{pkgs, ...}: let
  shellApps = import ./shellApps.nix {inherit pkgs;};

  commonPkgs = with pkgs;
    [
      # System
      fastfetch
      microfetch
      killall
      npins

      # Shells
      # keep-sorted start
      comma
      nushell
      starship
      tmux
      xonsh
      zellij
      # keep-sorted end

      # Editor
      helix
      vim

      # Development/Management
      python3
      lazygit
      difftastic
      gitFull
      tig

      # File/Navigation
      # keep-sorted start
      bat
      du-dust
      duf
      eza
      fd
      fzf
      ripgrep
      yazi
      zip
      zoxide
      # keep-sorted end

      # Graphical
      cage
      ghostty
      qutebrowser
      sakura

      # Performance
      atop
      btop
      htop

      # Hardware
      usbutils
      pciutils
      smartmontools
      lm_sensors

      # Machine Utilities
      gptfdisk
      parted
      lm_sensors
      usbutils
      pciutils

      # Web
      curl
      wget

      # Network
      # keep-sorted start
      bridge-utils
      cdpr
      dig
      ethtool
      frr
      inetutils
      iperf3
      lldpd
      ndisc6
      net-tools
      nmap
      tcpdump
      unixtools.arp
      unixtools.netstat
      vlan
      wireguard-tools
      # keep-sorted end
    ]
    ++ shellApps;
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
