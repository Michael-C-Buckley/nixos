{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.helium = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [flake.packages.${pkgs.stdenv.hostPlatform.system}.helium];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".config/net.imput.helium"];
        cache.directories = [".cache/net.imput.helium"];
      };
    };
  };
}
