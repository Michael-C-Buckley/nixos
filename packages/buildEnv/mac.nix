{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.macEnv = pkgs.buildEnv {
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
          (config.flake.packages.${pkgs.stdenv.hostPlatform.system})
          ns
          ;
      };
    };
  };
}
