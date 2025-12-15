{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules.darwin) default packages m1;
  inherit (config.flake) hjemConfig;
in {
  flake.darwinConfigurations.m1 = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      m1
      default
      packages
      hjemConfig.darwin
    ];
  };
}
