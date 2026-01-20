{config, ...}: {
  flake.hjemConfigs.extended = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) kitty;
  in {
    imports = with config.flake.hjemConfigs; [
      cursor
      git
      helium
      helix
      legcord
      librewolf
      materialgram
      novelwriter
      obsidian
      opencode
      signal
      zed
    ];

    hjem.users.michael = {
      packages = [
        pkgs.nvfetcher
        pkgs.yazi
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
