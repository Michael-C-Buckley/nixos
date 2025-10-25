{config, ...}: {
  flake.modules.nixos.packages = {pkgs, ...}: {
    nixpkgs.overlays = [config.flake.overlays.default];
    environment.systemPackages = with pkgs; [
      # Overlaid
      ns

      # System
      fastfetch
      microfetch
      killall
      npins

      # Security
      sops
      rage

      # Shells
      # keep-sorted start
      comma
      nushell
      starship
      tmux
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
      jujutsu
      gh
      nix-tree

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
      sops

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
    ];
  };
}
