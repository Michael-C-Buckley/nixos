{config, ...}: let
  inherit (config.flake) modules packageLists lib;
  inherit (config.flake.hjemConfigs) nixos root vim;
in {
  flake.modules.nixos.cloudPreset = {pkgs, ...}: {
    imports = with modules.nixos; [
      linuxPreset
      network
      zfs
      shawn
      pam-ssh
      packages

      # Users
      michael-attic
      michael-fish

      # Hjem
      nixos
      root
      vim
    ];

    environment.systemPackages = lib.packageLists.combinePkgLists pkgs (with packageLists; [
      cli
      network
    ]);
  };
}
