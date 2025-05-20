{
  config,
  pkgs,
  lib,
  user,
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) listOf str package;
  cfg = config.home.features.${user}.vscode;
in {
  options.home.features.${user}.vscode = {
    enable = mkEnableOption {};
    extensions = mkOption {
      type = listOf package;
      description = "Extensions from Nixpkgs.";
    };
    nonNixExtensions = mkOption {
      type = listOf str;
      description = "Extensions by name found in the vscode store.";
    };
  };

  config.home.features.${user} = mkIf cfg.enable {
    packageList = [
      (pkgs.vscode-with-extensions.override {
        vscodeExtensions =
          cfg.extensions ++ pkgs.nix4vscode.forVscode cfg.nonNixExtensions;
      })
    ];
  };
}
