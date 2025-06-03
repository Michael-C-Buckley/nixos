{
  pkgs,
  inputs,
  is-extended-version ? true,
  ...
}:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules =
    [./config/default.nix]
    ++ (
      if is-extended-version
      then [./config/extended.nix]
      else []
    );
})
.neovim
