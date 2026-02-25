{
  flake.hjemConfigs.helium = {pkgs, ...}: {
    # Just plumbs the necessary components for getting widevine working
    # Package is now part of my fullEnv package
    hjem.users.michael = {
      # Add widevine support, inspired from this comment:
      # https://github.com/imputnet/helium/issues/116#issuecomment-3668370766
      xdg.config.files."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
        {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
      '';
    };
  };
}
