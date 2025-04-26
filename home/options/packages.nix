{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) package enum;
in {
  options.features.michael = {
    nvf = {
      package = mkOption {
        type = enum ["default" "minimal"];
        default = "minimal";
      };
    };
    zed = {
      include = mkEnableOption {};
      package = mkOption {
        type = package;
        default = pkgs.zed-editor;
      };
    };
  };
}
