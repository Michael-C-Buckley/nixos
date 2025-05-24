{
  self,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.apps.editors.nvf;
in {
  options = {
    apps.editors.nvf = {
      enable = mkEnableOption "Install NVF";
      package = mkOption {
        type = lib.types.package;
        default = self.packages.${system}."nvf-minimal";
        description = "Package to use for NVF";
      };
    };
  };

  config = {
    packageList = mkIf cfg.enable [cfg.package];
  };
}
