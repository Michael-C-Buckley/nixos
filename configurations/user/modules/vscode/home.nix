{
  config,
  pkgs,
  ...
}: let
  cfg = config.features.michael.vscode.enable;
  home = config.features.michael.useHome;
in {
  home.packages =
    if cfg && home
    then import ./base.nix {inherit pkgs;}
    else [];
}
