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
        modules = [../packages/nvf] ++ extraModules;
      }).neovim;
  in {
    packages = {
      ns = pkgs.callPackage ../packages/shell/ns.nix {};
      gpg-custom = pkgs.callPackage ../packages/shell/gpg-custom.nix {
        inherit pkgs lib;
        inherit (self.packages.${pkgs.system}) gpg-find-key;
      };

      helium = pkgs.callPackage ../packages/helium.nix {};

      nvf = mkNvf [../packages/nvf/extended.nix];
      nvf-minimal = mkNvf [];

      gpg-find-key = pkgs.callPackage ../packages/gpg-find-key.nix {};
    };
  };
}
