{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ssh;
  valueType =
    with lib.types;
    either (oneOf [
      str
      int
      bool
    ]) (listOf str);
  renderValue =
    value: if builtins.isBool value then (if value then "yes" else "no") else toString value;
  renderSetting =
    key: value: lib.concatMapStringsSep "\n" (v: "  ${key} ${renderValue v}") (lib.toList value);
in
{
  options.programs.ssh = {
    enable = lib.mkEnableOption "OpenSSH client configuration";
    package = lib.mkPackageOption pkgs "openssh" { };
    includes = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
      default = [ ];
      description = "OpenSSH configuration paths or globs to include before Host blocks.";
    };
    matchBlocks = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            host = lib.mkOption {
              type = lib.types.singleLineStr;
              description = "Host patterns; list order determines OpenSSH's first-match precedence.";
            };
            settings = lib.mkOption {
              type = lib.types.attrsOf valueType;
              default = { };
              description = "OpenSSH directives. Lists repeat a directive; booleans render as yes/no.";
            };
          };
        }
      );
      default = [ ];
      description = "Ordered Host blocks. Use mkBefore/mkAfter to control precedence.";
    };
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];
    files.".ssh/config".text =
      lib.concatMapStrings (path: ''
        Include "${path}"
      '') cfg.includes
      + lib.concatMapStringsSep "\n" (block: ''
        Host ${block.host}
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList renderSetting block.settings)}
      '') cfg.matchBlocks;
  };
}
