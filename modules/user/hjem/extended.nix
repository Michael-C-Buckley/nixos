{config, ...}: {
  flake.hjemConfig.extended = {pkgs, ...}: {
    imports = with config.flake.hjemConfig; [
      cursor
      helix
      gpgAgent
      kitty
      ghostty
      zed
    ];

    hjem.users.michael = {
      gnupg.pinentryPackage = pkgs.pinentry-qt;

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
