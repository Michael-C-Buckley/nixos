{config, ...}: let
  inherit (config.flake) modules;
  inherit (config.flake.hjemConfig) nixos root;
in {
  flake.modules.nixos.cloudPreset = {
    imports = with modules.nixos; [
      linuxPreset
      network
      boot
      impermanence
      zfs
      shawn

      packages
      packages-network

      # Hjem
      nixos
      root
    ];

    programs.nvf.settings.imports = [modules.nvf.default];
  };
}
