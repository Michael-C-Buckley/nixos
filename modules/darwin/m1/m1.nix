{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules.darwin) default packages;
  inherit (config.flake) hjemConfig;
in {
  flake.darwinConfigurations.m1 = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      inputs.nix-secrets.darwinModules.michael
      default
      packages
      hjemConfig.darwin
    ];
  };
}
