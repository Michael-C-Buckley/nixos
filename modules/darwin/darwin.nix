{
  self,
  config,
  ...
}: let
  inherit (config.flake.modules) darwin;
  inherit (config.flake.custom) hjemConfigs;
in {
  flake.modules.darwin.default = {
    imports = builtins.attrValues {
      inherit (darwin) nix;
      inherit (hjemConfigs) ghostty;
    };
    nixpkgs.config.allowUnfree = true;

    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
