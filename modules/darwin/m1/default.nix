{
  self,
  config,
  ...
}: {
  flake.modules.darwin.m1 = {pkgs, ...}: {
    imports = with config.flake.modules.darwin; [
      ssh-agent
    ];

    nix.packages = pkgs.lix;

    nixpkgs.config.allowUnfree = true;

    # Set Git commit hash for darwin-version.
    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      stateVersion = 6;
    };
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
