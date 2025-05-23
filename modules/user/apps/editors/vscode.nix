{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) listOf str package;
  cfg = config.apps.editors.vscode;

  # Only run the helper if there's actually something to give it
  outOfStoreExt = if (cfg.nonNixExtensions != []) then
    pkgs.nix4vscode.forVscode cfg.nonNixExtensions
    else [];

in {
  options.apps.editors.vscode = {
    enable = mkEnableOption "Enable VScode";
    extensions = mkOption {
      type = listOf package;
      description = "Extensions from Nixpkgs.";
      default = [];
    };
    nonNixExtensions = mkOption {
      type = listOf str;
      description = "Extensions by name found in the vscode store via nix4vscode overlay.";
      default = [];
    };
  };

  config.packageList = mkIf cfg.enable [
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = cfg.extensions ++ outOfStoreExt;
    })
  ];
}
