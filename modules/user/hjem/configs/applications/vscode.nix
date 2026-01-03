{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.vscode = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [
        flake.packages.${pkgs.stdenv.hostPlatform.system}.vscode
      ];

      impermanence.persist.directories = lib.optionals config.custom.impermanence.home.enable [
        ".config/Code"
        ".vscode"
      ];
    };
  };
}
