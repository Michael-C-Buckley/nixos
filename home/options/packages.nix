{lib, pkgs, ...}: let 
  inherit (lib) types mkOption mkEnableOption;
  inherit (types) package;
in {
  options.features.michael.packages = {
    zed = {
      include = mkEnableOption{};
      package = mkOption {
        type = package;
        default = pkgs.zed-editor;
      };
    };
  };
}
