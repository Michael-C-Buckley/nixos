{
  flake.hjemConfigs.qt = {pkgs, ...}: {
    hjem.users.michael = {
      environment.sessionVariables = {
        # These are also in Hyprland since shell environment is not part of
        # the launcher and won't read in properly
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_STYLE_OVERRIDE = "kvantum";
        KDE_PLATFORM_THEME = "qt6ct";
      };

      packages = with pkgs.kdePackages; [
        qt6ct
        qtsvg
        qtstyleplugin-kvantum
      ];

      xdg.config.files = {
        "Kvantum/kvantum.kvconfig" = {
          type = "copy";
          permissions = "0644";
          text = ''
            [General]
            theme=KvAdaptaDark
          '';
        };
      };
    };
  };
}
