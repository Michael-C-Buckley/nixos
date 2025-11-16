{config, ...}: let
  inherit (config.flake) modules;
  inherit (config.flake.hjemConfig) nixos root;
in {
  flake.modules.nixos.serverPreset = {
    imports = with modules.nixos; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs
      gpg-yubikey
      shawn

      # Hjem
      nixos
      root

      # WIP:
      packages
      packages-server
      packages-physical
      packages-network
    ];

    programs.nvf.settings.imports = [modules.nvf.default];
  };
}
