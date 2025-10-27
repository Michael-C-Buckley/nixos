{config, ...}: {
  flake.modules.nixos.packages = {pkgs, ...}: {
    nixpkgs.overlays = [config.flake.overlays.default];
    environment.systemPackages = with pkgs; [
      # Overlaid local packages
      ns
      nvf-minimal

      # System
      fastfetch
      microfetch
      killall
      npins

      # Security
      sops
      rage

      # Shells
      comma
      nushell
      starship
      tmux
      zellij

      # Development/Management
      python3
      lazygit
      difftastic
      gitFull
      tig
      jujutsu
      gh
      nix-tree

      # File/Navigation
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
      sops

      # Web
      curl
      wget

      # Network
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
    ];
  };
}
