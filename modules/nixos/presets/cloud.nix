{config, ...}: let
  inherit (config.flake.modules) nixos nvf;
  inherit (config.flake.modules) hjem;
in {
  flake.modules.nixos.cloudPreset = {
    imports = with nixos;
      [
        linuxPreset
        network
        users
        boot
        impermanence
        zfs
        shawn

        packages
        packages-network
      ]
      ++ (with hjemModules; [default root]);

    programs.nvf.settings.imports = [nvf.default];
  };
}
