{config, ...}: {
  flake.hjemConfigs.extended = {pkgs, ...}: {
    imports = with config.flake.hjemConfigs; [
      cursor
      helium
      qt
      zed
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
