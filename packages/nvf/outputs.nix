# Transform my NVF modules into packages
{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    mkNvf = modules:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs modules;
      }).neovim;
  in {
    packages = {
      nvf = mkNvf [
        ./default.nix
        ./extended.nix
      ];
      nvf-minimal = mkNvf [
        ./default.nix
      ];
      nvf-vscode = mkNvf [
        ./vscode.nix
      ];
    };
  };
}
