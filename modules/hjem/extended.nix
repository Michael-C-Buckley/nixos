{config, ...}: {
  flake.hjemConfigs.extended = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) kitty zeditor;
  in {
    imports = with config.flake.hjemConfigs; [
      cursor
      helium
      helix
      termfilechooser
      zed
    ];

    hjem.users.michael = {
      packages = with pkgs; [
        nvfetcher
        yazi
        legcord
        materialgram
        novelwriter
        obsidian
        opencode
        signal-desktop

        kitty
        zeditor
      ];

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
