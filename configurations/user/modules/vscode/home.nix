{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.michael.vscode.enable;
  home = config.features.michael.useHome;
  useVscode = cfg && home;
in {
  home.packages =  lib.mkIf useVscode (import ./base.nix {inherit pkgs;});
}
