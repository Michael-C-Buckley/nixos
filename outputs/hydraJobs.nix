{self, ...}: let
  inherit (builtins) attrNames;
  inherit (self) nixosConfigurations;
  getConfig = host: self.nixosConfigurations.${host}.config.system.build.toplevel;
in {
  flake.hydraJobs = {
    # For now, only do the architectures I develop on
    devShells = self.devShells."x86_64-linux";

    # Find and build all systems defined
    nixosConfigurations = map getConfig (attrNames nixosConfigurations);
  };
}
