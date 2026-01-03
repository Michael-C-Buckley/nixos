# Include my Zed plus the persisted directories
{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.zed = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [flake.packages.${pkgs.stdenv.hostPlatform.system}.zeditor];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [
          ".config/zed"
          ".local/share/zed"
        ];
        cache.directories = [".cache/zed"];
      };
    };
  };
}
