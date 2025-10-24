{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nvf;
in {
  perSystem = {pkgs, ...}: let
    mkNvf = modules:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs modules;
      }).neovim;
  in {
    packages = {
      nvf = mkNvf [
        nvf.default
        nvf.extended
      ];
      nvf-copilot = mkNvf [
        nvf.copilot
        nvf.default
        nvf.extended
      ];
      nvf-minimal = mkNvf [
        nvf.default
      ];
      nvf-vscode = mkNvf [
        nvf.vscode
      ];
    };
  };
}
