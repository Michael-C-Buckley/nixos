{config, ...}: {
  flake.hjemConfigs.extended = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) ghostty kitty;
  in {
    imports = with config.flake.hjemConfigs; [
      cursor
      glide
      helix
      zed
    ];

    hjem.users.michael = {
      packages = [
        pkgs.nvfetcher
        pkgs.npins
        ghostty
        kitty
      ];

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
