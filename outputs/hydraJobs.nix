{self, ...}: let
  inherit (builtins) mapAttrs;
  inherit (self) nixosConfigurations;
  getConfig = host: self.nixosConfigurations.${host}.config.system.build.toplevel;
in {
  flake.hydraJobs = {
    # Find and build all systems defined
    nixosConfigurations = mapAttrs (n: _: getConfig n) nixosConfigurations;
  };
}
