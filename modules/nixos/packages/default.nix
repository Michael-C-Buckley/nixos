{config, ...}: {
  flake.modules.nixos.packages = {pkgs, ...}: let
    inherit (config.flake) packages packageLists lib;

    pkgList = lib.packageLists.combinePkgLists pkgs (with packageLists; [
      cli
    ]);

    flakePkgs = with packages.${pkgs.stdenv.hostPlatform.system}; [
      ns
    ];

    localPkgs = with pkgs; [
      # System
      fastfetch
      microfetch
      killall
      npins

      # Performance
      atop
      btop
      htop

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
