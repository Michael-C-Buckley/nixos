{config, ...}: {
  flake.hjemConfigs.helium = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.helium];

      # Add widevine support, inspired from this comment:
      # https://github.com/imputnet/helium/issues/116#issuecomment-3668370766
      xdg.config.files."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
        {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
      '';
    };
  };
}
