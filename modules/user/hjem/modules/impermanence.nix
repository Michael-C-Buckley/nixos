# The custom settings I use to define impermanence at a per-user basis
# Mainly reused within various application definitions
{
  flake.hjemModules.impermanence = {lib, ...}: let
    inherit (lib) mkOption mkEnableOption;
    inherit (lib.types) listOf str;

    volumes = ["cache" "persist"];
  in {
    options.impermanence =
      {
        enable = mkEnableOption "Triggers associated with applications defined in hjem.";
      }
      // (builtins.listToAttrs (
        map (
          name: {
            inherit name;
            value = {
              directories = mkOption {
                type = listOf str;
                default = [];
                description = "Create binds for the specified directories for the user's ${name} volume.";
              };
              files = mkOption {
                type = listOf str;
                default = [];
                description = "Create binds for the specified files to the user's ${name} volume.";
              };
            };
          }
        )
        volumes
      ));
  };
}
