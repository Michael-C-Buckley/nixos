{config, ...}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.extended = {pkgs, ...}: {
    imports = with flake.custom.hjemConfigs; [
      cursor
      helium
      qt
    ];

    hjem.users.michael = {
      packages = with pkgs; [
        novelwriter
        obsidian
        opencode
      ];

      environment.sessionVariables = {
        BROWSER = "helium";
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  };
}
