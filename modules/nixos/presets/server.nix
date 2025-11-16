{config, ...}: let
  inherit (config.flake.modules) nixos nvf;
  inherit (config.flake) hjemConfig;
in {
  flake.modules.nixos.serverPreset = {
    imports = with nixos; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs
      gpg-yubikey
      hjemConfig.default
      hjemConfig.root
      shawn

      # WIP:
      packages
      packages-server
      packages-physical
      packages-network
    ];

    programs.nvf.settings.imports = with nvf; [default];
  };
}
