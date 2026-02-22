{
  config,
  lib,
  ...
}: {
  flake.hjemConfigs.extended = {pkgs, ...}: let
    wpkgs = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
    wrappedPkgs = map lib.hiPrio (with wpkgs; [
      helix
      kitty
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

    environment.shellAliases = {
      mhx = lib.getExe wpkgs.helix;
    };

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
