# Common system options for all NixOS machines
{lib, ...}: let
  inherit (builtins) attrNames listToAttrs;
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) attrsOf listOf str submodule;

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

  mkSet = {
    directories = mkDirectoryOption;
    files = mkFileOption;
  };

  userSubmodule = submodule {
    options = {
      directories = mkDirectoryOption;
      files = mkFileOption;
    };
  };
in {
  flake.modules.nixos.options = {config, ...}: let
    hjemUsers = attrNames config.hjem.users;

    getHjemInfo = vol:
      listToAttrs (map (name: {
          inherit name;
          value = config.hjem.users.${name}.impermanence.${vol};
        })
        hjemUsers);
  in {
    # All are nested under a custom namespace that does not conflict with nixpkgs
    options.custom = {
      # Impermanence options separate from the flake input so systems can be agnostic to it
      impermanence = {
        home.enable = mkEnableOption "Triggers `/home` to bind out locations that apps use.";
        var.enable = mkEnableOption "Triggers `/var/` to bind out locations that apps use.";
        enable = mkEnableOption "Set various flags for impermanence options within the config.";
        cache = {
          allUsers = mkSet;
          directories = mkDirectoryOption;
          files = mkFileOption;
          users = mkOption {
            type = attrsOf userSubmodule;
            default = {};
            description = "Per-user cache directories and files, keyed by username.";
          };
        };
        persist = {
          allUsers = mkSet;
          directories = mkDirectoryOption;
          files = mkFileOption;
          users = mkOption {
            type = attrsOf userSubmodule;
            default = {};
            description = "Per-user persist directories and files, keyed by username.";
          };
        };
      };
      shell = {
        environmentVariables = mkOption {
          type = attrsOf str;
          default = {};
          description = "Environment variables to pass to the wrapped shell.";
        };
      };
    };

    config = {
      custom.impermanence = {
        persist.users = getHjemInfo "persist";
        cache.users = getHjemInfo "cache";
      };
    };
  };
}
