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
      macEnv = pkgs.buildEnv {
        # Packages I use on macs that don't ship my whole env
        name = "mac-env";
        paths = with pkgs; [
          nix-tree
          nix-direnv
          nil
          nixd
        ];
      };
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
