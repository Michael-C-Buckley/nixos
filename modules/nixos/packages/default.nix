{config, ...}: {
  flake.modules.nixos.packages = {
    pkgs,
    functions,
    ...
  }: let
    inherit (config.flake) packages packageLists;
    inherit (functions.packageLists) combinePkgLists;

    pkgList = combinePkgLists (with packageLists; [
      cli
    ]);

    flakePkgs = with packages.${pkgs.stdenv.hostPlatform.system}; [
      ns
    ];

    localPkgs = with pkgs; [
      # System
      killall
      expect

      # Performance
      btop

      # Hardware
      usbutils
      pciutils

      # Machine Utilities
      gptfdisk
      parted
      usbutils
      pciutils
    ];
  in {
    environment.systemPackages = localPkgs ++ flakePkgs ++ pkgList;
  };
}
