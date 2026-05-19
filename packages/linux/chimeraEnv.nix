{
  inputs,
  pkgs,
  system,
  ...
}: let
  local = inputs.self.packages.${system};
in {
  chimeraEnv = pkgs.buildEnv {
    name = "chimera-runtime-env";
    paths = builtins.attrValues {
      inherit
        (local)
        # zeditor
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
}
