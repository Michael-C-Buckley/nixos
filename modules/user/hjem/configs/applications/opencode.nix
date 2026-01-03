{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.opencode = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [
        flake.packages.${pkgs.stdenv.hostPlatform.system}.opencode
      ];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".config/opencode"];
        cache.directories = [
          ".cache/opencode"
          ".local/share/opencode"
        ];
      };
    };
  };
}
