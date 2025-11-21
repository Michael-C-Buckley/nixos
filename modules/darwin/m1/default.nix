# First draft for a nix-darwin config
{self, ...}: {
  flake.modules.darwin.default = {
    # This is a Determinate system
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;

    programs = {
      direnv.enable = true;
    };

    # Set Git commit hash for darwin-version.
    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      stateVersion = 6;
    };
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
