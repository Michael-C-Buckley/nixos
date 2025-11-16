{config, ...}: let
  inherit (config.flake.modules) nixos nvf;
  inherit (config.flake) hjemConfig;
in {
  flake.modules.nixos.desktopPreset = {
    imports = with nixos; [
      linuxPreset
      hyprland
      noctalia
      tuigreet
      gpg-yubikey
      ssh-agent
      dconf
      tpm2
      impermanence
      zfs
      boot
      users
      hjemConfig.extended
      hjemConfig.root
      shawn

      cosmicDesktop

      packages
      packages-desktop
      packages-development
      packages-fonts
      packages-network

      app-bitwarden
      app-helium
      app-jan
      app-legcord
      app-librewolf
      app-materialgram
      app-obsidian
      app-qutebrowser
      app-signal
      app-vscode
      app-zed
    ];

    programs.nvf.settings.imports = [nvf.extended];

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
