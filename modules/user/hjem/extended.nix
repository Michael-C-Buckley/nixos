{config, ...}: {
  flake.hjemConfig.extended = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) ghostty helix kitty;
  in {
    imports = with config.flake.hjemConfig; [
      cursor
      gpgAgent
      zed
    ];

    hjem.users.michael = {
      gnupg.pinentryPackage = pkgs.pinentry-qt;

      packages = [
        pkgs.nvfetcher
        pkgs.npins
        ghostty
        kitty
        helix
      ];

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
