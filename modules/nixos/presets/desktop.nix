{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos nvf;
in {
  flake.modules.nixos.desktopPreset = {
    imports = with nixos;
      [
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
        hjem-extended
        hjem-root
        shawn

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
      ]
      ++ [
        inputs.microvm.nixosModules.host
      ];

    programs.nvf.settings.imports = [nvf.extended];

    # MicroVM Devbox
    custom.impermanence.cache.directories = ["/var/lib/microvms"];

    # WIP: Attach the VM's tap

    # Host bridge configuration
    networking = {
      bridges.br0.interfaces = ["vm-devbox"];
      interfaces.br0 = {
        ipv4.addresses = [
          {
            address = "192.168.254.254";
            prefixLength = 31;
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
