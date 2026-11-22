{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nh;
  flakeOption = lib.mkOption {
    type = with lib.types; nullOr (either singleLineStr path);
    default = null;
    description = "Default flake path for NH.";
  };
in
{
  options.programs.nh = {
    enable = lib.mkEnableOption "NH";
    package = lib.mkPackageOption pkgs "nh" { };
    flake = flakeOption;
    osFlake = flakeOption;
    darwinFlake = flakeOption;
    homeFlake = flakeOption;
  };

  config = lib.mkIf cfg.enable {
    packages = [ cfg.package ];
    environment.sessionVariables = lib.mkMerge [
      (lib.mkIf (cfg.flake != null) { NH_FLAKE = cfg.flake; })
      (lib.mkIf (cfg.osFlake != null) { NH_OS_FLAKE = cfg.osFlake; })
      (lib.mkIf (cfg.darwinFlake != null) { NH_DARWIN_FLAKE = cfg.darwinFlake; })
      (lib.mkIf (cfg.homeFlake != null) { NH_HOME_FLAKE = cfg.homeFlake; })
    ];
  };
}
