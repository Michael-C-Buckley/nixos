{inputs, pkgs, ...}: {
  zsh = pkgs.callPackage ../packages/zsh {inherit inputs;};
}
