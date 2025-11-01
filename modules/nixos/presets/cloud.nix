{config, ...}: let
  inherit (config.flake.modules) nixos nvf;
in {
  flake.modules.nixos.cloudPreset = {
    imports = with nixos; [
      linuxPreset
      network
      users
      boot
      impermanence
      zfs
      hjem-default
      hjem-root
      shawn

      packages
      packages-network
    ];

    programs.nvf.settings.imports = [nvf.default];
  };
}
