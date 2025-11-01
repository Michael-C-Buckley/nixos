{
  config,
  inputs,
  ...
}: let
  inherit
    (config.flake.modules.nvf)
    copilot
    default
    extended
    vscode
    ;
in {
  perSystem = {pkgs, ...}: let
    mkNvf = modules:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs modules;
      }).neovim;
  in {
    packages = {
      nvf = mkNvf [extended];
      nvf-copilot = mkNvf [copilot extended];
      nvf-minimal = mkNvf [default];
      nvf-vscode = mkNvf [vscode];
    };
  };
}
