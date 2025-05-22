{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf package;

  mkPkgSet = description:
    mkOption {
      type = listOf package;
      default = [];
      description = description;
    };
in {
  imports = [
    ./common.nix
    ./minimalGraphical.nix
    ./extendedGraphical.nix
  ];

  options.packageSets = {
    common = mkPkgSet "A common package set to be reused in many places.";
    minimalGraphical = mkPkgSet "Package set with minimal graphical apps for servers.";
    extendedGraphical = mkPkgSet "Full set for desktop/laptop/full systems.";
  };
}
