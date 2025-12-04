{config, ...}: let
  inherit (config.flake) modules;
  inherit (config.flake.hjemConfig) nixos root extended;
in {
  flake.modules.nixos.desktopPreset = {
    imports = with modules.nixos; [
      linuxPreset
      boot
      impermanence
      shawn
      zfs

      # Network
      network
      dnscrypt-proxy
      netbird

      # Virtualization
      containerlab
      libvirt

      # Userspace
      cosmicDesktop
      dconf
      hyprland
      tuigreet
      noctalia

      # Security
      clamav
      gpg-yubikey
      ssh-agent
      tpm2
      pam-yubikey
      secrets

      packages
      packages-desktop
      packages-development
      packages-fonts
      packages-network

      app-bitwarden
      app-helium
      app-legcord
      app-librewolf
      app-materialgram
      app-obsidian
      app-qutebrowser
      app-signal
      app-vscode
      app-zed

      # Hjem
      nixos
      root
      extended
    ];

    programs.nvf.settings.imports = [modules.nvf.extended];

    # MicroVM Devbox
    custom.impermanence.cache.directories = ["/var/lib/microvms"];

    # Host bridge configuration
    networking = {
      bridges.br0.interfaces = [];
      interfaces.br0 = {
        ipv4.addresses = [
          {
            # Non-routable within my network, local to the host-only
            address = "192.168.254.193";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };
}
