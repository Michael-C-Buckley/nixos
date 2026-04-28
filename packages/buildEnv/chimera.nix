{config, ...}: {
  perSystem = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    packages.chimeraEnv = pkgs.buildEnv {
      name = "chimera-runtime-env";
      paths = builtins.attrValues {
        inherit
          (local)
          zeditor
          #helium
          ns
          ;

        inherit
          (pkgs)
          nix-tree
          nix-direnv
          ;
      };
    };
  };
}
