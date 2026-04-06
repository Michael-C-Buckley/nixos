# I have one Mac in the form of an M1 Mac Mini
# It's managed by Nix-Darwin and Hjem and I
# mainly pull configs from things like my
# Hjem and wrapped apps
{
  config,
  inputs,
  ...
}: let
  mkCfg = {hostname, ...}:
    inputs.nix-darwin.lib.darwinSystem {
      modules = builtins.attrValues {
        inherit
          (config.flake.modules.darwin)
          default
          packages
          ;

        inherit (config.flake.custom.hjemConfigs) darwin;

        localhost = config.flake.modules.darwin.${hostname};
      };
    };
  macs = {
    m1 = {};
    m4 = {};
  };
in {
  flake.darwinConfigurations =
    builtins.mapAttrs (
      hostname: params: mkCfg (params // {inherit hostname;})
    )
    macs;
}
