{
  pkgs,
  system,
  inputs,
  ...
}: {
  macEnv = pkgs.buildEnv {
    # Packages I use on macs that don't ship my whole env
    name = "mac-env";
    paths = builtins.attrValues {
      inherit
        (pkgs)
        # Openssh from nixpkgs has better libfido2 support
        openssh
        # Nix Tools
        nix-tree
        nix-direnv
        alejandra
        nil
        nixd
        ;

      inherit
        (inputs.self.packages.${system})
        ns
        ;
    };
  };
}
