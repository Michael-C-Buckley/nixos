{config, lib, pkgs, ...}: let
  plugins = import ./vscode-plugins.nix {inherit pkgs lib;};
  cfg = config.features.michael.vscode.enable;
in {
  users.users.michael.packages = (if cfg then import ./base.nix {inherit pkgs plugins;} else []);
}