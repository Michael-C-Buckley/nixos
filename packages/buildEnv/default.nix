# First attempt
{
  config,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    local = config.flake.packages.${system};

    commonFullPkgs = builtins.attrValues {
      inherit
        (local)
        nushell
        helix
        zeditor
        ghostty
        kitty
        ;
    };
  in {
    packages = {
      termEnv = pkgs.buildEnv {
        # Extra packages for CLI hosts like development servers
        name = "Michael's terminal env";
        paths = with local; [
          nushell
          helix
        ];
      };
      fullEnv = pkgs.buildEnv {
        # Fully loaded graphical environments
        name = "Michael's full env";
        paths =
          commonFullPkgs
          ++ lib.optionals (lib.hasSuffix "linux" system) [
            local.helium
            local.librewolf-jailed
          ];
      };
    };
  };
}
