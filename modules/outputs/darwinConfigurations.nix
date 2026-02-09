# I have one Mac in the form of an M1 Mac Mini
# It's managed by Nix-Darwin and Hjem and I
# mainly pull configs from things like my
# Hjem and wrapped apps
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules.darwin) default packages m1;
  inherit (config.flake) hjemConfigs;
in {
  flake.darwinConfigurations.m1 = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      m1
      default
      packages
      hjemConfigs.darwin
    ];
  };
}
