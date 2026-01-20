{config, ...}: let
  inherit (config.flake) modules packageLists lib;
  inherit (config.flake.hjemConfigs) nixos root;
in {
  flake.modules.nixos.cloudPreset = {pkgs, ...}: {
    imports = with modules.nixos; [
      linuxPreset
      network
      boot
      impermanence
      zfs
      shawn
      pam-ssh
      packages

      # Users
      michael-attic

      # Hjem
      nixos
      root
    ];

    environment.systemPackages = lib.packageLists.combinePkgLists pkgs (with packageLists; [
      cli
      network
    ]);
  };
}
