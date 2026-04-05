{config, ...}: let
  inherit (config.flake) modules packageLists;
  inherit (config.flake.custom) hjemConfigs;
in {
  flake.modules.nixos.cloudPreset = {
    pkgs,
    functions,
    ...
  }: {
    imports =
      builtins.attrValues
      {
        inherit
          (modules.nixos)
          linuxPreset
          network
          zfs
          shawn
          pam-ssh
          packages
          # Users
          michael-attic
          ;

        inherit
          (hjemConfigs)
          nixos
          root
          ;
      };

    environment.systemPackages =
      functions.packageLists.combinePkgLists (with packageLists; [
        cli
        network
      ])
      ++ [
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.vim
      ];
  };
}
