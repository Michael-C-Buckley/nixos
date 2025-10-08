{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    mkNvf = extraModules:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [../flake/packages/nvf] ++ extraModules;
      }).neovim;
  in {
    packages = {
      ns = pkgs.callPackage ../flake/packages/shell/ns.nix {};
      gpg-custom = pkgs.callPackage ../flake/packages/shell/gpg-custom.nix {
        inherit pkgs lib;
        inherit (self.packages.${pkgs.system}) gpg-find-key;
      };

      nvf = mkNvf [../flake/packages/nvf/extended.nix];
      nvf-minimal = mkNvf [];

      gpg-find-key = pkgs.callPackage ../flake/packages/gpg-find-key.nix {};
    };
  };
}
