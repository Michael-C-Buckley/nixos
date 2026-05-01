{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.hjem-extended = {pkgs, ...}: {
    imports = with flake.modules.nixos; [
      hjem-cursor
      hjem-helium
      hjem-qt
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
