{config, ...}: {
  flake.hjemConfigs.extended = {pkgs, ...}: let
    wrappedPkgs = with config.flake.packages.${pkgs.stdenv.hostPlatform.system}; [kitty zeditor];
  in {
    imports = with config.flake.hjemConfigs; [
      cursor
      dolphin
      helium
      helix
      zed
    ];

    hjem.users.michael = {
      packages = with pkgs;
        [
          nvfetcher
          legcord
          materialgram
          novelwriter
          obsidian
          opencode
          signal-desktop
        ]
        ++ wrappedPkgs;

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
