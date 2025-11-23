# Wrapped starship with custom config bundled
{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      env = {
        STARSHIP_CONFIG = import ./_config.nix {inherit pkgs;};
      };
    };
  };
}
