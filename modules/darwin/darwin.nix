{
  self,
  config,
  ...
}: let
  inherit (config.flake.modules) darwin;
in {
  flake.modules.darwin.default = {
    imports = builtins.attrValues {
      inherit (darwin) nix;
    };
    nixpkgs.config.allowUnfree = true;

    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
