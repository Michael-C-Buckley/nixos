# Common system options for all NixOS machines
{lib, ...}: let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;

  mkDirectoryOption = mkOption {
    type = listOf str;
    default = [];
    description = "Create binds for the specified directories to the drive matching the option namespace.";
  };
  mkFileOption = mkOption {
    type = listOf str;
    default = [];
    description = "Create binds for the specified files to the drive matching the option namespace.";
  };
in {
  flake.modules.nixos.options = {
    # All are nested under a custom namespace that does not conflict with nixpkgs
    options.custom = {
      # Impermanence options separate from the flake input so systems can be agnostic to it
      impermanence = {
        cache = {
          directories = mkDirectoryOption;
          files = mkFileOption;
          user = {
            directories = mkDirectoryOption;
            files = mkFileOption;
          };
        };
        persist = {
          directories = mkDirectoryOption;
          files = mkFileOption;
          user = {
            directories = mkDirectoryOption;
            files = mkFileOption;
          };
        };
      };
      # End impermanence
    };
  };
}
