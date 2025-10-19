# Transform my NVF modules into packages
{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    mkNvf = modules:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs modules;
      }).neovim;
  in {
    packages = {
      nvf = mkNvf (with self.modules.nvf; [
        default
        extended
      ]);
      nvf-minimal = mkNvf (with self.modules.nvf; [
        default
      ]);
      nvf-vscode = mkNvf (with self.modules.nvf; [
        vscode
      ]);
    };
  };
}
