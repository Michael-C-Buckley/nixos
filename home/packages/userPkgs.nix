# Base Entry for the Hjem outputs
{config, pkgs, lib, commonPackages}: let
  inherit (lib) optionals ;
  inherit (config.features.michael) minimalGraphical extendedGraphical;
  zed = config.features.michael.packages.zed;
in 

commonPackages
++ optionals minimalGraphical (import ./minimalGraphical.nix { inherit pkgs; })
++ optionals extendedGraphical (import ./extendedGraphical.nix { inherit pkgs; })
++ optionals zed.include ([zed.package])