# Base Entry for the Hjem outputs
{
  config,
  lib,
  ...
}: let
  inherit (config) packageSets;
  inherit (lib) optionals;
  inherit (config.features.michael) minimalGraphical extendedGraphical;
in
  packageSets.common
  ++ optionals minimalGraphical packageSets.minimalGraphical
  ++ optionals extendedGraphical packageSets.extendedGraphical
