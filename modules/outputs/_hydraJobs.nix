{config, ...}: let
  inherit (builtins) mapAttrs;
  inherit (config.flake) nixosConfigurations;
  getConfig = host: nixosConfigurations.${host}.config.system.build.toplevel;
in {
  flake.hydraJobs = {
    # Find and build all systems defined
    nixosConfigurations = mapAttrs (n: _: getConfig n) nixosConfigurations;
  };
}
