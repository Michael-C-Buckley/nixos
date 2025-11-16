{config, ...}: let
  inherit (config.flake.modules) nixos nvf;
  inherit (config.flake) hjemConfig;
in {
  flake.modules.nixos.cloudPreset = {
    imports = with nixos; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs
      hjemConfig.default
      hjemConfig.root
      shawn

      packages
      packages-network
    ];

    programs.nvf.settings.imports = [nvf.default];
  };
}
