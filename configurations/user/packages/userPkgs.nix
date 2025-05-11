# Base Entry for the Hjem outputs
{
  config,
  inputs,
  pkgs,
  lib,
  commonPackages,
  system,
  ...
}: let
  inherit (lib) optionals;
  inherit (config.features.michael) minimalGraphical extendedGraphical;
in
  commonPackages
  ++ optionals minimalGraphical (import ./minimalGraphical.nix {inherit pkgs;})
  ++ optionals extendedGraphical (import ./extendedGraphical.nix {inherit inputs pkgs system;})
