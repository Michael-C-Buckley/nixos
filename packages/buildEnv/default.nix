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
        ns
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

      macEnv = pkgs.buildEnv {
        # For use on Macs, obviously, so no jails or incompatible apps
        name = "macos-buildenv";
        paths = commonFullPkgs;
      };

      fullEnv = pkgs.buildEnv {
        # Fully loaded graphical environments
        name = "Michael's full env";
        paths =
          commonFullPkgs
          ++ lib.optionals (lib.hasSuffix "linux" system) [
            local.ghostty
            local.helium
            local.librewolf-jailed
            local.kitty
          ];
      };
    };
  };
}
