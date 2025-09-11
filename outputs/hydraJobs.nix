{self, ...}: {
  # The various components that should be built, which is the devShells by definitions
  #  and the systems, by their top level reference
  flake.hydraJobs = {
    inherit (self) devShells;
    nixosConfigurations = {
      # Let's start simple and build the hosts
      x570 = self.nixosConfigurations.x570.config.system.build.toplevel;
      p520 = self.nixosConfigurations.p520.config.system.build.toplevel;
      t14 = self.nixosConfigurations.t14.config.system.build.toplevel;
    };
  };
}
