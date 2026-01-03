{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.glide = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [flake.packages.${pkgs.stdenv.hostPlatform.system}.glide];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [
          ".config/glide"
        ];
        cache.directories = [
          ".cache/glide"
          ".config/mozilla/glide"
        ];
      };
    };
  };
}
