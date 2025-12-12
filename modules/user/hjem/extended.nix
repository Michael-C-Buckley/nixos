{config, ...}: {
  flake.hjemConfig.extended = {pkgs, ...}: {
    imports = with config.flake.hjemConfig; [
      cursor
      helix
      gpgAgent
      ghostty
      zed
    ];

    hjem.users.michael = {
      gnupg.pinentryPackage = pkgs.pinentry-qt;

      packages = [
        pkgs.nvfetcher
        pkgs.npins
        config.flake.packages.${pkgs.stdenv.hostPlatform.system}.kitty
      ];

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
