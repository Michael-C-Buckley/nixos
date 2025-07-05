{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf optionals;
  inherit (lib.types) package;
  inherit (pkgs) vscode vscode-fhs vscodium vscodium-fhs;
  cfg = config.programs.vscode;

  imperm = config.system.impermanence.enable;
  impermDir =
    if (cfg.package == (vscodium || vscodium-fhs))
    then [".config/VSCodium" ".vscode-oss/extensions"]
    else if (cfg.package == (vscode || vscode-fhs))
    then [".config/Code" ".vscode/extensions"]
    else [];
in {
  options.programs.vscode = {
    enable = mkEnableOption "Enable vscode editor (default is vscodium)";
    package = mkOption {
      type = package;
      default = pkgs.vscodium-fhs;
      description = "The package to use (and potentially swap for alt client).";
    };
  };

  config = mkIf cfg.enable {
    system.impermanence.userPersistDirs = optionals imperm impermDir;
    packageList = [cfg.package];
  };
}
