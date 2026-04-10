{
  self,
  config,
  ...
}: {
  flake.modules.darwin.default = {
    imports = builtins.attrValues {
      inherit (config.flake.modules.darwin) nix;
    };
    nixpkgs.config.allowUnfree = true;

    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
