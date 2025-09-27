{
  pkgs,
  lib,
  ...
}: let
  getPkgs = file: (import ../packageSets/${file}.nix {inherit pkgs;});
  inherit (lib) concatMap;
in {
  imports = [
    ./configs/cursor.nix
    ../modules/vscodium.nix
  ];

  hjem.users.michael = {
    packages = concatMap getPkgs ["extendedGraphical" "minimalGraphical" "linuxDesktop"];
  };
}
