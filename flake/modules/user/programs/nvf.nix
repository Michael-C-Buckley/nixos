{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.programs.nvf;
in {
  options = {
    programs.nvf = {
      enable = mkEnableOption "Install NVF";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.nvf;
        description = "Package to use for NVF";
      };
    };
  };

  config = {
    packageList = mkIf cfg.enable [cfg.package];
  };
}
