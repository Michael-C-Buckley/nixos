{config, ...}: let
  inherit (config.flake) modules packageLists;
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
          hjem
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
