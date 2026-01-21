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

      # Add widevine support, inspired from this comment:
      # https://github.com/imputnet/helium/issues/116#issuecomment-3668370766
      xdg.config.files."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
        {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
      '';

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".config/net.imput.helium"];
        cache.directories = [".cache/net.imput.helium"];
      };
    };
  };
}
