{config, ...}: let
  inherit (config.flake) modules custom;
in {
  flake.modules.nixos.cloudPreset = {functions, ...}: {
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

    environment.systemPackages = functions.packageLists.combinePkgLists (with custom.packageLists; [
      cli
      network
    ]);
  };
}
