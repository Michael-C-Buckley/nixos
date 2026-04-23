# First attempt
{config, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    local = config.flake.packages.${system};

    commonPkgs = builtins.attrValues {
      inherit
        (local)
        nushell
        fish
        helix
        ns
        ;
    };
  in {
    packages = {
      termEnv = pkgs.buildEnv {
        # Extra packages for CLI hosts like development servers
        name = "Michael's terminal env";
        paths = commonPkgs;
      };

      fullEnv = pkgs.buildEnv {
        # Fully loaded graphical environments
        name = "Michael's full env";
        paths = with local;
          [
            ghostty
            helium
            librewolf-jailed
            kitty
            zeditor
          ]
          ++ commonPkgs;
      };
    };
  };
}
