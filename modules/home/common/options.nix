# Intended to generate manifests for smfh
{
  flake.modules.homeManager.default = {lib, ...}: let
    inherit (lib) mkOption;
    inherit (lib.types) str path nullOr int bool attrsOf submodule;
  in {
    options.custom = {
      files = mkOption {
        type = attrsOf (submodule {
          options = {
            type = mkOption {
              type = str;
              default = "symlink";
              description = "Type of the operation (e.g., copy symlink).";
            };
            source = mkOption {
              type = path;
              description = "Source path for the file.";
            };
            target = mkOption {
              type = str;
              description = "Target path relative to home directory.";
            };
            permissions = mkOption {
              type = nullOr str;
              default = null;
              description = "File permissions in octal format.";
            };
            uid = mkOption {
              type = nullOr int;
              default = null;
              description = "Owner user ID.";
            };
            gid = mkOption {
              type = nullOr int;
              default = null;
              description = "Owner group ID.";
            };
            clobber = mkOption {
              type = bool;
              default = false;
              description = "Whether to overwrite existing files.";
            };
          };
        });
        default = {};
        description = "Attrset of files to manage.";
      };
      smfh.manifest = mkOption {
        type = nullOr path;
        description = "The manifest location for smfh to link from.";
      };
    };
  };
}
