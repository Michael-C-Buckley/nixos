# I split packages into groups based on usage then enable as needed
{config, ...}: {
  flake.nixosModules.packages = {pkgs, ...}: let
    flakeExtraPkgs = builtins.map (x: pkgs.${x}) config.host.graphicalPackages;
  in {
    environment.systemPackages = with pkgs;
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
      ]
      ++ flakeExtraPkgs;
  };
}
