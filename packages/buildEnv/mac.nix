{
  perSystem = {pkgs, ...}: {
    packages.macEnv = pkgs.buildEnv {
      # Packages I use on macs that don't ship my whole env
      name = "mac-env";
      paths = with pkgs; [
        nix-tree
        nix-direnv

        # Nix Tools
        alejandra
        nil
        nixd
      ];
    };
  };
}
