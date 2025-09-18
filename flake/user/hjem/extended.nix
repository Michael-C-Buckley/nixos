# Split into per-host basis
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
  ];

  users.users.michael = {
    packages = concatMap getPkgs ["extendedGraphical" "minimalGraphical" "linuxDesktop"];
  };
}
