{
  system,
  inputs,
}: extraModules:
(inputs.nvf.lib.neovimConfiguration {
  pkgs = import inputs.nixpkgs {inherit system;};
  modules = [../config/default.nix] ++ extraModules;
})
.neovim
