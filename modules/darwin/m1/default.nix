{
  self,
  config,
  ...
}: {
  flake.modules.darwin.m1 = {
    imports = with config.flake.modules.darwin; [
      ssh-agent
    ];

    # This is a Determinate system
    nix.enable = false;

    nixpkgs.config.allowUnfree = true;

    # Set Git commit hash for darwin-version.
    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      stateVersion = 6;
    };
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
