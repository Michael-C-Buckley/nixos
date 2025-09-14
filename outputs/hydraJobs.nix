{self, ...}: let
  inherit (builtins) elem mapAttrs;
  inherit (self) devShells nixosConfigurations;
  inherit (self.inputs.nixpkgs.lib) filterAttrs;
  getConfig = host: self.nixosConfigurations.${host}.config.system.build.toplevel;

  # Currently the only systems I use DevShells on
  validSystems = ["x86_64-linux"];
in {
  flake.hydraJobs = {
    # For now, only do the architectures I develop on
    devShells = filterAttrs (n: _: elem n validSystems) devShells;

    # Find and build all systems defined
    nixosConfigurations = mapAttrs (n: _: getConfig n) nixosConfigurations;
  };
}
