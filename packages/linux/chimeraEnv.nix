{
  inputs,
  pkgs,
  system,
  ...
}: let
  local = inputs.self.packages.${system};
  nix-tools = builtins.attrValues {inherit (pkgs) nix-tree nix-direnv alejandra nil nixd;
  inherit        (inputs.self.packages.${system})
        ns
        ;};
in {
  gentooEnv = pkgs.buildEnv {
    name = "gentoo-env";
    paths = with pkgs; [
      yazi
      pcmanfm
    ] ++ nix-tools;

    };
  chimeraEnv = pkgs.buildEnv {
    name = "chimera-runtime-env";
    paths = nix-tools;
  };
}
