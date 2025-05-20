{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.michael.vscode.enable;
in {
  users.users.michael.packages = lib.mkIf cfg (import ./base.nix {inherit pkgs;});
}
