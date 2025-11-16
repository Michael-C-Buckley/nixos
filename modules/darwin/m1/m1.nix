{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules.darwin) default vscode;
  inherit (config.flake) hjemConfig;
in {
  flake.darwinConfigurations.m1 = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      default
      hjemConfig.darwin
      vscode
    ];
  };
}
