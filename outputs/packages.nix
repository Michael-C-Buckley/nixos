{inputs, pkgs, ...}: {
  # For now, this nvim, more will come in the future as I make a minimal edition without tooling
  nvim = pkgs.callPackage ../packages/nvim {};
  zsh = pkgs.callPackage ../packages/zsh {inherit inputs;};
}
