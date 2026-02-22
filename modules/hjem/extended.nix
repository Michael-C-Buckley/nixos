{
  config,
  lib,
  ...
}: {
  flake.hjemConfigs.extended = {pkgs, ...}: let
    wrappedPkgs = map lib.hiPrio (with config.flake.packages.${pkgs.stdenv.hostPlatform.system}; [
      helix
      kitty
      nushell
      vscode
      zeditor
    ]);
  in {
    imports = with config.flake.hjemConfigs; [
      cursor
      helium
      qt
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
