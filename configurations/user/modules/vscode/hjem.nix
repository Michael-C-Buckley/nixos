{
  config,
  pkgs,
  ...
}: let
  cfg = config.features.michael.vscode.enable;
in {
  users.users.michael.packages =
    if cfg
    then import ./base.nix {inherit pkgs;}
    else [];
}
